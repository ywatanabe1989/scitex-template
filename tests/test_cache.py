"""Tests for scitex_template._cache."""

from pathlib import Path

import pytest

from scitex_template import _cache


def _make_fake_monorepo(root: Path) -> Path:
    """Create a minimal scitex-template-shaped directory under ``root``."""
    (root / "templates" / "alpha").mkdir(parents=True)
    (root / "templates" / "alpha" / "file.txt").write_text("hello")
    (root / "templates" / "alpha" / "sub").mkdir()
    (root / "templates" / "alpha" / "sub" / "deep.txt").write_text("deep")
    # Intra-template relative symlink — mirrors the real research template
    (root / "templates" / "alpha" / "link").symlink_to("file.txt")
    (root / "templates" / "REGISTRY.yaml").write_text(
        "templates:\n"
        "  - id: alpha\n"
        "    description: test\n"
        '    version: "0.0.1"\n'
        "    path: templates/alpha\n"
    )
    return root


class TestCloneTemplateFromCache:
    def test_populates_target(self, tmp_path, monkeypatch):
        fake_cache = tmp_path / "cache"
        _make_fake_monorepo(fake_cache)

        monkeypatch.setattr(_cache, "CACHE_ROOT", fake_cache)
        # Skip the network clone — registry already resolves against fake_cache
        monkeypatch.setattr(_cache, "ensure_cache", lambda **kw: fake_cache)
        # Point registry at the same fake root
        from scitex_template import registry

        monkeypatch.setattr(registry, "_editable_checkout_root", lambda: None)
        monkeypatch.setattr(registry, "CACHE_ROOT", fake_cache)

        target = tmp_path / "out"
        result = _cache.clone_template_from_cache("alpha", target)

        assert result == target
        assert (target / "file.txt").read_text() == "hello"
        assert (target / "sub" / "deep.txt").read_text() == "deep"
        # Symlink preserved + resolves to the copied file
        assert (target / "link").is_symlink()
        assert (target / "link").resolve() == (target / "file.txt").resolve()

    def test_unknown_template_raises(self, tmp_path, monkeypatch):
        fake_cache = tmp_path / "cache"
        _make_fake_monorepo(fake_cache)
        monkeypatch.setattr(_cache, "CACHE_ROOT", fake_cache)
        monkeypatch.setattr(_cache, "ensure_cache", lambda **kw: fake_cache)
        from scitex_template import registry

        monkeypatch.setattr(registry, "_editable_checkout_root", lambda: None)
        monkeypatch.setattr(registry, "CACHE_ROOT", fake_cache)

        with pytest.raises(KeyError, match="bogus"):
            _cache.clone_template_from_cache("bogus", tmp_path / "out")

    def test_non_empty_target_raises(self, tmp_path, monkeypatch):
        fake_cache = tmp_path / "cache"
        _make_fake_monorepo(fake_cache)
        monkeypatch.setattr(_cache, "CACHE_ROOT", fake_cache)
        monkeypatch.setattr(_cache, "ensure_cache", lambda **kw: fake_cache)
        from scitex_template import registry

        monkeypatch.setattr(registry, "_editable_checkout_root", lambda: None)
        monkeypatch.setattr(registry, "CACHE_ROOT", fake_cache)

        target = tmp_path / "out"
        target.mkdir()
        (target / "existing").write_text("x")

        with pytest.raises(FileExistsError):
            _cache.clone_template_from_cache("alpha", target)


class TestEnsureCache:
    def test_pulls_when_present(self, tmp_path, monkeypatch):
        """Already-present .git dir → git pull path (we don't exercise network)."""
        cache = tmp_path / "cache"
        (cache / ".git").mkdir(parents=True)
        monkeypatch.setattr(_cache, "CACHE_ROOT", cache)

        # Mock subprocess.run to capture the pull invocation and succeed.
        calls = []

        def fake_run(cmd, **kw):
            calls.append(cmd)

            class R:
                returncode = 0
                stderr = ""

            return R()

        monkeypatch.setattr(_cache.subprocess, "run", fake_run)
        result = _cache.ensure_cache()
        assert result == cache
        # First call should be `git -C <cache> pull --ff-only --depth 1`
        assert calls[0][:3] == ["git", "-C", str(cache)]
        assert "pull" in calls[0]
