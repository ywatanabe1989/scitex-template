<!-- 02_structure.md -->

# Directory Structure

```
pip-project-template/
├── pyproject.toml           # Metadata + deps (rename here first)
├── Makefile                 # install / test / lint / coverage targets
├── README.md                # Replace boilerplate banners
├── src/<pkg>/
│   ├── __init__.py
│   ├── __main__.py          # python -m <pkg>
│   ├── core/                # Business logic (example: Calculator)
│   ├── cli/                 # Click CLI entrypoints
│   ├── mcp_servers/         # FastMCP 2.0 servers (optional)
│   ├── types/               # Typed dataclasses / protocols
│   └── utils/               # Stateless helpers
├── tests/
│   ├── <pkg>/               # Mirrors src/<pkg>/ layout
│   ├── custom/              # Repo-specific extra tests
│   ├── github_actions/      # Local `act` runner setup
│   └── reports/             # Coverage / test report outputs
├── mgmt/
│   ├── utils/rename.sh      # Placeholder-rename helper (used in quick-start)
│   └── AGENTS/              # Agent role definitions (Architect, Debugger, …)
├── examples/                # Runnable demos / notebooks
├── config/                  # YAML config
└── data/                    # Sample data
```

## Conventions

- **Tests mirror src**: every module in `src/<pkg>/foo/bar.py` has a
  counterpart at `tests/<pkg>/foo/test_bar.py`.
- **Agents under mgmt/AGENTS/**: each role (ArchitectAgent,
  TestDeveloperAgent, …) has a markdown spec used by agentic workflows.
- **Keep or remove `mcp_servers/`** based on whether your package ships
  an MCP interface. Remove the FastMCP dependency from `pyproject.toml`
  if you drop it.
- **`tests/github_actions/`** hosts a local `act` configuration so CI
  can be exercised offline before pushing.
