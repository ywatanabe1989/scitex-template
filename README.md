<p align="center">
  <img src="docs/assets/images/scitex-logo-blue-cropped.png" alt="SciTeX" width="400">
</p>

# SciTeX Template (`scitex-template`)

<p align="center"><b>Project template cloner + code snippet library for the SciTeX ecosystem.</b></p>

<p align="center">
  <a href="https://badge.fury.io/py/scitex-template"><img src="https://badge.fury.io/py/scitex-template.svg" alt="PyPI version"></a>
  <a href="https://github.com/ywatanabe1989/scitex-template/actions/workflows/test.yml"><img src="https://github.com/ywatanabe1989/scitex-template/actions/workflows/test.yml/badge.svg" alt="Tests"></a>
  <a href="https://www.gnu.org/licenses/agpl-3.0"><img src="https://img.shields.io/badge/License-AGPL--3.0-blue.svg" alt="License: AGPL-3.0"></a>
</p>

<p align="center">
  <code>pip install scitex-template</code> · <code>pip install scitex[template]</code>
</p>

---

## Problem

SciTeX ecosystem users need starting points for three distinct project kinds — a minimal scitex-* package, a full research project, a cloud-module plugin — plus boilerplate for pip projects, LaTeX manuscripts, singularity containers. Each of those template repos evolves independently, and the glue code that clones them (`clone_research`, `clone_pip_project`, …) has historically lived buried inside `scitex-python` where its release cadence doesn't match.

## Solution

`scitex-template` is the standalone cloner. One install gives you every `clone_*` function, the code-snippet library for scitex idioms (session decorator, io save/load, plt subplots, …), the project-config generators (`create_project_config`, `build_directory_tree`), and the MCP server that exposes the same operations to agents.

## Installation

```bash
pip install scitex-template              # core (lazy imports for scitex.git / scitex.logging / scitex.scholar)
pip install scitex-template[mcp]         # MCP server deps (fastmcp)
pip install scitex-template[dev]         # pytest + coverage
```

The umbrella route also works — `pip install scitex[template]` pulls this package transitively.

## Python usage

```python
import scitex  # noqa: F401 — ensures scitex.git / .logging are importable

from scitex_template import (
    clone_research,
    clone_pip_project,
    clone_scitex_minimal,
    get_available_templates_info,
    get_code_template,
)

# Clone a research project template
clone_research(target="my-experiment", project_name="my-experiment")

# Discover available templates
for info in get_available_templates_info():
    print(f"{info['id']:>10}  {info['description']}")

# Pull a code snippet for a scitex session script
print(get_code_template("session"))
```

The legacy import path `from scitex.template import …` also still works via a compatibility shim in `scitex-python`.

## CLI

Entry point: `scitex-template` (also `python -m scitex_template`).

```bash
scitex-template                           # starts MCP server
```

CLI parity with the Python API is planned; for now the cloners are invoked programmatically.

## Template repos

`scitex-template` clones from these external repositories:

| Template id | Repo |
|---|---|
| `research` | [scitex-research-template](https://github.com/ywatanabe1989/scitex-research-template) |
| `app` / `pip` | [pip-project-template](https://github.com/ywatanabe1989/pip-project-template) |
| `cloud-module` | [scitex-template-cloud-module](https://github.com/ywatanabe1989/scitex-template-cloud-module) |
| `minimal` | [scitex-minimal-template](https://github.com/ywatanabe1989/scitex-minimal-template) |
| `singularity` | [singularity_template](https://github.com/ywatanabe1989/singularity_template) |
| `paper` | [paper-template](https://github.com/ywatanabe1989/paper-template) |

A future revision may vendor these as `templates/<id>/` subdirs in this repo so the cloner and the templates ship in lockstep.

## Dependency notes

Per the SciTeX downstream dependency rule (general/01_arch_02), this package aims to avoid a hard runtime dep on the `scitex` umbrella. At present three submodules are still imported lazily inside `clone_*` functions: `scitex.git`, `scitex.logging`, `scitex.scholar.ensure_workspace`. Once `scitex-git` is extracted as a standalone, those imports will move to the standalone equivalents (`scitex_git`, `scitex_logging`, `scitex_scholar`). Users running `pip install scitex[template]` pick up the umbrella transitively, so there is no current breakage.

## License

AGPL-3.0-only.

## Part of SciTeX

`scitex-template` is part of [**SciTeX**](https://scitex.ai).

> Four Freedoms for Research
>
> 0. The freedom to **run** your research anywhere — your machine, your terms.
> 1. The freedom to **study** how every step works — from raw data to final manuscript.
> 2. The freedom to **redistribute** your workflows, not just your papers.
> 3. The freedom to **modify** any module and share improvements with the community.
>
> AGPL-3.0 — because we believe research infrastructure deserves the same freedoms as the software it runs on.

---

<p align="center">
  <a href="https://scitex.ai" target="_blank"><img src="docs/assets/images/scitex-icon-navy-inverted.png" alt="SciTeX" width="40"/></a>
</p>
