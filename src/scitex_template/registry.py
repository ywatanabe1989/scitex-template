"""Registry of templates vendored in this repo.

Reads ``templates/REGISTRY.yaml`` from either:
  1. the live git checkout of scitex-template (editable install), or
  2. ``~/.scitex/template/cache/templates/REGISTRY.yaml`` (shallow-clone cache,
     populated on first cloner call).

The wheel installed from PyPI intentionally does NOT ship ``templates/`` — it
contains only the cloner code. At runtime the cloner clones this repo shallowly
into ``~/.scitex/template/cache/`` and reads the registry + template payload
from there. Keeps the wheel <100KB while the git repo stays the single source
of truth.
"""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from scitex_config._ecosystem import local_state
from typing import Optional

try:
    import yaml
except ImportError as _e:  # pragma: no cover
    raise ImportError(
        "scitex-template requires PyYAML. pip install scitex-template"
    ) from _e


CACHE_ROOT = local_state.runtime_path("template", "cache")


@dataclass(frozen=True)
class TemplateEntry:
    id: str
    description: str
    version: str
    path: Path


def _editable_checkout_root() -> Optional[Path]:
    """If this module lives inside an editable scitex-template checkout, return
    the repo root (parent of ``src/``). Otherwise return None.
    """
    here = Path(__file__).resolve()
    # .../<repo>/src/scitex_template/registry.py → repo = parents[2]
    candidate = here.parents[2]
    if (candidate / "templates" / "REGISTRY.yaml").is_file():
        return candidate
    return None


def registry_root() -> Optional[Path]:
    """Return the directory that contains ``templates/REGISTRY.yaml``.

    Preference order:
      1. Editable checkout (if we're running from ``src/scitex_template/``).
      2. Cache at ``~/.scitex/template/cache/``.
      3. None — caller should populate the cache.
    """
    live = _editable_checkout_root()
    if live is not None:
        return live
    if (CACHE_ROOT / "templates" / "REGISTRY.yaml").is_file():
        return CACHE_ROOT
    return None


def load_registry() -> list[TemplateEntry]:
    """Parse ``templates/REGISTRY.yaml`` and return every entry.

    Raises ``FileNotFoundError`` if neither the editable checkout nor the
    cache is populated — the caller is responsible for triggering a
    shallow-clone of the scitex-template repo into ``~/.scitex/template/cache/``.
    """
    root = registry_root()
    if root is None:
        raise FileNotFoundError(
            f"no template registry found — expected either an editable "
            f"checkout of scitex-template or a populated cache at {CACHE_ROOT}"
        )
    data = yaml.safe_load((root / "templates" / "REGISTRY.yaml").read_text()) or {}
    return [
        TemplateEntry(
            id=item["id"],
            description=item["description"],
            version=item["version"],
            path=root / item["path"],
        )
        for item in data.get("templates", [])
    ]


def find_template(template_id: str) -> Optional[TemplateEntry]:
    """Return the registry entry for ``template_id``, or None."""
    for entry in load_registry():
        if entry.id == template_id:
            return entry
    return None
