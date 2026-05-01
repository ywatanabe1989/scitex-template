---
name: scitex-template
description: Project scaffolding cloner + code snippet library for the SciTeX ecosystem. 6 templates (pip-project, minimal, cloud-module, research, singularity, paper) vendored in a single monorepo, populated into user targets via `~/.scitex/template/cache/` shallow-clone. Exposes Python API, CLI (`scitex-template clone <id> <target>`), and MCP tools.
user-invocable: false
tags: [scitex-template, scitex-package]
invocation:
  - "clone a scitex research template"
  - "create a new scitex-* package skeleton"
  - "scaffold a pip project"
---

# scitex-template

Standalone cloner for the SciTeX ecosystem's six project templates. Every
template lives vendored under `templates/<id>/` in this monorepo. Wheel
stays ~100 KB; content populated on first use by a shallow-clone into
`~/.scitex/template/cache/`.

## The six templates

| id | purpose |
|---|---|
| `pip-project` | Generic Python pip package (CI, tests, docs) |
| `minimal` | Minimal scitex-* starter (src/tests/pyproject only) |
| `cloud-module` | SciTeX Cloud workspace module (TS + Python) |
| `research` | Full research project + writer + scholar + MNIST |
| `singularity` | Apptainer/Singularity recipe + build scripts |
| `paper` | LaTeX manuscript scaffold |

## Public surface

```bash
scitex-template list                      # enumerate templates
scitex-template info research             # one template's metadata
scitex-template clone research ./my-proj  # populate from cache
scitex-template cache-refresh             # re-clone monorepo
```

```python
from scitex_template import clone_template_from_cache, load_registry

clone_template_from_cache("research", "./my-proj")
for entry in load_registry():
    print(entry.id, entry.version, entry.description)
```

MCP tools: `template_list`, `template_info`, `template_clone`,
`template_cache_refresh`.

## Sub-skills

- [01_quick-start.md](01_quick-start.md), [02_python-api.md](02_python-api.md),
  [03_cli-reference.md](03_cli-reference.md), [04_mcp-tools.md](04_mcp-tools.md)
- [10_project-templates.md](10_project-templates.md),
  [11_code-templates.md](11_code-templates.md),
  [12_git-strategies.md](12_git-strategies.md),
  [13_config-generators.md](13_config-generators.md),
  [14_scholar-writer-integration.md](14_scholar-writer-integration.md)
- [20_env-vars.md](20_env-vars.md)

## Architecture

- **Wheel small, content in git.** `templates/<id>/` excluded from wheel
  (~22 MB); first `clone_*` runs `git clone --depth 1` into
  `~/.scitex/template/cache/`.
- **Local-state per `01_arch_06`** — cache at `~/.scitex/template/cache/`
  (honors `SCITEX_DIR`).
- **Downstream-clean per `01_arch_02`** — zero runtime dep on the scitex
  umbrella for the cache fast-path; legacy remote-clone uses `scitex.git`
  via `[legacy]` extra.
