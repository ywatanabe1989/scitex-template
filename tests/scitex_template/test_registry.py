"""Tests for scitex_template.registry."""

from pathlib import Path

import pytest

from scitex_template import registry


class TestRegistryRoot:
    def test_editable_checkout_is_preferred(self):
        """In this repo's test env, the editable checkout wins over the cache."""
        root = registry.registry_root()
        assert root is not None
        assert (root / "templates" / "REGISTRY.yaml").is_file()

    def test_cache_root_fallback(self, tmp_path, monkeypatch):
        """If no editable checkout is detected, fall back to the cache path."""
        # Force the editable-root lookup to fail
        monkeypatch.setattr(registry, "_editable_checkout_root", lambda: None)

        # Cache missing → None
        monkeypatch.setattr(registry, "CACHE_ROOT", tmp_path / "nonexistent")
        assert registry.registry_root() is None

        # Cache present → returned
        fake_cache = tmp_path / "cache"
        (fake_cache / "templates").mkdir(parents=True)
        (fake_cache / "templates" / "REGISTRY.yaml").write_text("templates: []\n")
        monkeypatch.setattr(registry, "CACHE_ROOT", fake_cache)
        assert registry.registry_root() == fake_cache


class TestLoadRegistry:
    def test_returns_all_six_templates(self):
        entries = registry.load_registry()
        ids = {e.id for e in entries}
        assert ids == {
            "pip-project",
            "minimal",
            "cloud-module",
            "research",
            "singularity",
            "paper",
        }

    def test_entries_have_required_fields(self):
        for e in registry.load_registry():
            assert e.id
            assert e.description
            assert e.version
            assert isinstance(e.path, Path)

    def test_missing_registry_raises(self, tmp_path, monkeypatch):
        monkeypatch.setattr(registry, "_editable_checkout_root", lambda: None)
        monkeypatch.setattr(registry, "CACHE_ROOT", tmp_path / "nope")
        with pytest.raises(FileNotFoundError):
            registry.load_registry()


class TestFindTemplate:
    def test_hit(self):
        entry = registry.find_template("pip-project")
        assert entry is not None
        assert entry.id == "pip-project"

    def test_miss_returns_none(self):
        assert registry.find_template("does-not-exist") is None
