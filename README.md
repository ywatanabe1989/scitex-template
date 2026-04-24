# scitex-template

Project template cloner + code snippet library for the [SciTeX](https://scitex.ai) ecosystem.

Extracted from `scitex.template` in [scitex-python](https://github.com/ywatanabe1989/scitex-code) so the cloner + its skills can evolve independently of the umbrella. `scitex.template` remains available as a compatibility shim — every existing import path keeps working.

## Install

```bash
pip install scitex-template
# or, via the scitex umbrella:
pip install scitex[template]
```

## What's inside

- **Project cloners** — `clone_research`, `clone_pip_project`, `clone_scitex_minimal`, `clone_module`, `clone_singularity`, `clone_writer_directory`, `clone_research_minimal`
- **Code snippet library** — `get_code_template`, `list_code_templates` for scitex-idiom boilerplate
- **Customization** — `customize_template`, project config generators, README generators
- **Scholar/Writer integration** — `setup_scholar_writer_integration`
- **MCP server** — `scitex_template.mcp_server:main` (console script: `scitex-template`)

## Relationship to the template repos

This package is the **cloner**. It downloads from (or, future, vendors) these external template repos:

| Template | GitHub repo |
|---|---|
| `scitex-research-template` | [ywatanabe1989/scitex-research-template](https://github.com/ywatanabe1989/scitex-research-template) |
| `pip-project-template` | [ywatanabe1989/pip-project-template](https://github.com/ywatanabe1989/pip-project-template) |
| `scitex-template-cloud-module` | [ywatanabe1989/scitex-template-cloud-module](https://github.com/ywatanabe1989/scitex-template-cloud-module) |
| `scitex-minimal-template` | [ywatanabe1989/scitex-minimal-template](https://github.com/ywatanabe1989/scitex-minimal-template) |
| `singularity_template` | [ywatanabe1989/singularity_template](https://github.com/ywatanabe1989/singularity_template) |
| `paper-template` | [ywatanabe1989/paper-template](https://github.com/ywatanabe1989/paper-template) |

A future revision may vendor these as `templates/<name>/` subdirs so the cloner and the templates ship in lockstep.
