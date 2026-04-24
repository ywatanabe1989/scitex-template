"""Populate ``~/.scitex/template/cache/`` with a shallow clone of
``ywatanabe1989/scitex-template`` so the vendored ``templates/`` subtree is
available locally.

Wheel-installed users don't have ``templates/`` on disk (it's intentionally
excluded from the wheel to keep the download tiny). The first cloner call
triggers ``ensure_cache()`` which populates the cache; subsequent calls
``git pull`` to stay current.

Directory names follow general/01_arch_06: ``<pkg-short>`` = ``template``
(``scitex-`` prefix stripped; singular, not plural).
"""

from __future__ import annotations

import shutil
import subprocess
from pathlib import Path

MONOREPO_URL = "https://github.com/ywatanabe1989/scitex-template.git"
CACHE_ROOT = Path.home() / ".scitex" / "template" / "cache"


def ensure_cache(branch: str = "main", force_refresh: bool = False) -> Path:
    """Ensure the scitex-template monorepo is shallow-cloned at ``CACHE_ROOT``.

    Returns the cache root. Raises ``RuntimeError`` on clone/pull failure.

    Idempotent: subsequent calls ``git pull`` the existing checkout rather
    than re-cloning. Pass ``force_refresh=True`` to wipe and re-clone.
    """
    CACHE_ROOT.parent.mkdir(parents=True, exist_ok=True)

    if force_refresh and CACHE_ROOT.exists():
        shutil.rmtree(CACHE_ROOT)

    if not (CACHE_ROOT / ".git").is_dir():
        CACHE_ROOT.parent.mkdir(parents=True, exist_ok=True)
        if CACHE_ROOT.exists():
            shutil.rmtree(CACHE_ROOT)
        result = subprocess.run(
            [
                "git",
                "clone",
                "--depth",
                "1",
                "--branch",
                branch,
                MONOREPO_URL,
                str(CACHE_ROOT),
            ],
            capture_output=True,
            text=True,
        )
        if result.returncode != 0:
            raise RuntimeError(
                f"failed to shallow-clone {MONOREPO_URL} into {CACHE_ROOT}: "
                f"{result.stderr.strip()}"
            )
    else:
        result = subprocess.run(
            ["git", "-C", str(CACHE_ROOT), "pull", "--ff-only", "--depth", "1"],
            capture_output=True,
            text=True,
        )
        # pull can fail if the remote rebased; treat as non-fatal and keep
        # existing cache so offline workflows still proceed
        if result.returncode != 0:
            # Try a deeper fetch + reset to recover
            subprocess.run(
                ["git", "-C", str(CACHE_ROOT), "fetch", "origin", branch],
                capture_output=True,
                text=True,
            )
            subprocess.run(
                ["git", "-C", str(CACHE_ROOT), "reset", "--hard", f"origin/{branch}"],
                capture_output=True,
                text=True,
            )

    return CACHE_ROOT


def clone_template_from_cache(
    template_id: str,
    target: str | Path,
    branch: str = "main",
    force_refresh: bool = False,
) -> Path:
    """Populate ``target`` with the contents of ``templates/<template_id>/``.

    Ensures the cache is present/fresh, then copies the subdir via ``cp -r``
    semantics (no symlinks, no .git pollution). Returns the populated target.

    Raises:
        KeyError: if ``template_id`` is not in the registry.
        FileExistsError: if ``target`` exists and is non-empty.
    """
    from .registry import find_template

    cache_root = ensure_cache(branch=branch, force_refresh=force_refresh)

    # Refresh the registry from the cache view (not the editable checkout)
    # by importing against cache_root.
    entry = find_template(template_id)
    if entry is None:
        raise KeyError(
            f"template {template_id!r} is not in the registry. "
            f"Available: see scitex_template.registry.load_registry()"
        )

    target_path = Path(target)
    if target_path.exists() and any(target_path.iterdir()):
        raise FileExistsError(f"target {target_path} already exists and is not empty")
    target_path.mkdir(parents=True, exist_ok=True)

    # entry.path resolves against registry_root(). If the editable checkout
    # exists, it wins; otherwise it resolves to CACHE_ROOT/templates/<id>/.
    source = entry.path
    if not source.exists():
        # Registry resolved to editable checkout but that's not the cache.
        # Fall back to cache explicitly.
        source = cache_root / "templates" / template_id

    for child in source.iterdir():
        dst = target_path / child.name
        if child.is_dir():
            shutil.copytree(child, dst)
        else:
            shutil.copy2(child, dst)

    return target_path
