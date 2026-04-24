---
name: scitex-research-template
description: Standard template for scientific research projects using the SciTeX framework. Provides reproducible experiment tracking, automated data management, manuscript writing, and publication-ready visualization.
---

# SciTeX Research Template

## Overview

This template provides the standard directory layout for a SciTeX-powered research project. It includes an MNIST example pipeline demonstrating the full workflow: data download, visualization, modeling, and evaluation.

## Creating a New Project

```bash
# Recommended: use the scitex CLI
scitex template clone research ./my_project

# Alternative: clone directly from GitHub
git clone https://github.com/ywatanabe1989/scitex-research-template.git my_project
cd my_project
make install
```

After cloning, remove the example pipeline if not needed:

```bash
make clean-mnist
```

## Directory Layout

```
my_project/
├── config/              # YAML configuration (PATH.yaml, etc.)
├── data/                # Centralized data (symlinked from script outputs)
├── scripts/             # Analysis scripts (the main workspace)
│   ├── mnist/           # Example pipeline (remove with make clean-mnist)
│   └── template.py      # Starting point for new scripts
├── tests/               # Test suite
├── scitex/              # SciTeX-managed resources
│   ├── writer/          # Manuscripts (LaTeX, cloned on-demand)
│   ├── scholar/         # Bibliography and research library
│   ├── vis/             # Figure management
│   ├── code/            # Code templates
│   ├── ai/              # AI prompts and conversations
│   └── uploads/         # File staging area
├── management/          # Git-tracked project management (meeting notes, decisions)
├── GITIGNORED/          # Untracked working files (drafts, temp data, AI conversations)
├── externals/           # External dependencies
├── docs/                # Documentation
└── Makefile             # Automation commands
```

## Writing Experiment Scripts

Every experiment script should use the `@stx.session` decorator for reproducibility:

```python
#!/usr/bin/env python3
# File: scripts/my_experiment/01_analyze.py

import scitex as stx

@stx.session(seed=42)
def main(
    # Parameters become CLI arguments automatically
    n_samples=1000,        # --n_samples 1000
    learning_rate=0.01,    # --learning_rate 0.01
    # Injected objects (do not pass manually)
    CONFIG=stx.INJECTED,  # Session metadata (ID, paths, timestamps)
    plt=stx.INJECTED,     # Pre-configured matplotlib
    logger=stx.INJECTED,  # Auto-logging to files
):
    """Describe what this script does. This becomes --help text."""

    # Save outputs with provenance tracking
    stx.io.save(results, "results.csv")

    # Save figures (also exports underlying data as CSV)
    fig, ax = plt.subplots()
    ax.plot(x, y)
    stx.io.save(fig, "plot.png")

    # Symlink to centralized data/ directory
    stx.io.save(
        data, "data/my_experiment/output.npy",
        symlink_to="../../data/my_experiment/"
    )

    return 0

if __name__ == "__main__":
    main()
```

Running a script creates an output directory with session tracking:

```
scripts/my_experiment/01_analyze.py
scripts/my_experiment/01_analyze_out/
└── FINISHED_SUCCESS/
    └── A7K2/                # 4-char session ID
        ├── logs/
        │   ├── stdout.log
        │   └── stderr.log
        ├── CONFIGS/
        │   └── CONFIG.yaml  # Full reproducibility record
        └── [your outputs]
```

## Adding a New Experiment

1. Create a directory under `scripts/`:
   ```bash
   mkdir scripts/my_experiment
   cp scripts/template.py scripts/my_experiment/01_preprocess.py
   ```

2. Number scripts for execution order: `01_`, `02_`, `03_`, etc.

3. Create a `main.sh` to orchestrate all steps:
   ```bash
   #!/bin/bash
   set -e
   DIR="$(cd "$(dirname "$0")" && pwd)"
   python "$DIR/01_preprocess.py" "$@"
   python "$DIR/02_train.py" "$@"
   python "$DIR/03_evaluate.py" "$@"
   ```

4. Add a Makefile target (optional):
   ```makefile
   run-my-experiment:
       bash scripts/my_experiment/main.sh
   ```

## SciTeX Subdirectories

| Directory | Purpose | How to Set Up |
|-----------|---------|---------------|
| `scitex/writer/` | LaTeX manuscripts (00_shared, 01_manuscript, 02_supplementary, 03_revision) | `make setup-writer` or `scitex writer clone scitex/writer/my_paper` |
| `scitex/scholar/` | Bibliography files (.bib) and PDF library | Automatic; add papers with `scitex scholar add paper.pdf` |
| `scitex/vis/` | Figure management, gallery templates | Automatic; import figures with `scitex vis import path/to/fig.png` |
| `scitex/code/` | Code templates and AI-assisted coding prompts | Automatic |
| `scitex/ai/` | Centralized AI prompts (symlinks to module-level prompts) | Automatic |

## management/ vs GITIGNORED/

| Aspect | `management/` | `GITIGNORED/` |
|--------|---------------|---------------|
| Git tracked | Yes | No (gitignored) |
| Purpose | Project management artifacts | Working files, scratch space |
| Contents | Meeting notes, decisions, setup scripts, management shell scripts | Drafts, temporary data, AI conversation logs, TODO lists, personal notes |
| Audience | Team (shared via git) | Individual (local only) |

## CLI Commands

```bash
# Project templates
scitex template clone research ./my_project    # Full research project
scitex template clone minimal ./my_project     # Minimal (writer + scholar)
scitex template clone pip-project ./my_package # Python package
scitex template list                           # List available templates

# Code templates
scitex template get session                    # Print session script template
scitex template get io                         # I/O operations template
scitex template get all                        # All templates combined
scitex template get session -o script.py       # Save to file

# Makefile shortcuts
make install          # Install dependencies
make setup            # Full setup
make setup-writer     # Initialize manuscript
make run-mnist        # Run example pipeline
make test             # Run tests
make check            # Format + lint + test
make clean-all        # Full cleanup
```

## Key Patterns

- **stx.io.save/load**: Universal file I/O (30+ formats), automatic directory creation
- **@stx.session**: Reproducible experiment tracking with session IDs, logging, fixed seeds
- **Symlink architecture**: Script outputs symlinked to `data/` for central access with provenance
- **Writer integration**: LaTeX manuscripts with shared resources (title, authors, bibliography)
