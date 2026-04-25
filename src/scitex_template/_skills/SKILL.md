---
name: scitex-template
description: Project scaffolding cloner + code snippet library for the SciTeX ecosystem. 6 templates (pip-project, minimal, cloud-module, research, singularity, paper) vendored in a single monorepo, populated into user targets via `~/.scitex/template/cache/` shallow-clone. Exposes Python API, CLI (`scitex-template clone <id> <target>`), and MCP tools.
user-invocable: false
canonical-location: scitex-template/src/scitex_template/_skills/SKILL.md
tags: [scitex-template, scitex-package]
invocation:
  - "clone a scitex research template"
  - "create a new scitex-* package skeleton"
  - "new LaTeX manuscript project"
  - "scaffold a pip project"
  - "what templates are available"
  - "scitex-template CLI"
---

# scitex-template

Standalone cloner for the SciTeX ecosystem's six project templates. As of
0.2.0 every template lives vendored under `templates/<id>/` inside this
monorepo — no more scattered upstream repos. The wheel stays ~100 KB; the
actual template content is populated on first use by a shallow-clone of
this repo into `~/.scitex/template/cache/`.

## The six templates

| id | purpose |
|---|---|
| `pip-project` | Generic Python pip-installable package (CI, tests, docs) |
| `minimal` | Minimal scitex-* starter (src/tests/pyproject only) |
| `cloud-module` | SciTeX Cloud workspace module (TypeScript + Python backend) |
| `research` | Full research project with writer + scholar + MNIST example |
| `singularity` | Apptainer/Singularity container recipe + build scripts |
| `paper` | LaTeX manuscript scaffold (compile/manuscript/revision/supplementary) |

## Interfaces

### CLI (primary — works without the scitex umbrella)

```bash
pip install scitex-template

scitex-template list                       # enumerate the 6 templates
scitex-template info research              # details of one
scitex-template clone research ./my-proj   # populate target from cache
scitex-template cache-refresh              # force re-clone monorepo
```

### Python API

```python
from scitex_template import clone_template_from_cache, load_registry

# New path (post-0.2.0) — reads from ~/.scitex/template/cache/
clone_template_from_cache("research", "./my-proj")

# Enumerate
for entry in load_registry():
    print(entry.id, entry.version, entry.description)

# Legacy top-level imports (kept for back-compat)
from scitex_template import clone_research, clone_pip_project
clone_research("./my-proj")      # internally uses the cache fast-path
```

### MCP

Tool names follow the ecosystem prefix convention:

| tool | action |
|---|---|
| `template_list` | Enumerate templates (JSON) |
| `template_info` | Get one template's metadata |
| `template_clone` | Populate a target from the cache |
| `template_cache_refresh` | Force-refresh `~/.scitex/template/cache/` |

## Sub-skills

- [project-templates.md](project-templates.md) — cloner internals: `clone_project` dispatcher, fast-path vs legacy flow, cache layout
- [code-templates.md](code-templates.md) — `get_code_template`, `list_code_templates`, all 14 snippet IDs (`session`, `io`, `plt`, `stats`, …)
- [git-strategies.md](git-strategies.md) — `git_strategy={"child","parent","origin",None}`
- [config-generators.md](config-generators.md) — `create_project_config`, `build_directory_tree`, README generators
- [scholar-writer-integration.md](scholar-writer-integration.md) — bibliography symlink between scholar and writer workspaces

## Architecture notes

**Wheel is small; content is in git.** `pyproject.toml` ships only
`src/scitex_template/` in the wheel. The `templates/` directory (22 MB) is
in the git repo but excluded from the wheel. First use of `clone_*`
triggers `_cache.ensure_cache()` which runs `git clone --depth 1
https://github.com/ywatanabe1989/scitex-template` into
`~/.scitex/template/cache/`.

**Local-state directory per `01_arch_06`.** Cache at
`~/.scitex/template/cache/` (pkg-short = `template`, singular; honors
`SCITEX_DIR` env var for relocation).

**Downstream-clean per `01_arch_02`.** `scitex-template` has zero runtime
dependency on the scitex umbrella for the cache fast-path; the legacy
remote-clone flow still uses `scitex.git` via the `[legacy]` optional
extra.

**Six upstream repos archived.** `pip-project-template`,
`scitex-template-cloud-module`, `scitex-research-template`,
`singularity_template`, `paper-template` on GitHub now show a "⚠️ Moved"
banner pointing at `templates/<id>/` in this repo. `scitex-minimal-template`
never existed on GitHub; nothing to archive.
