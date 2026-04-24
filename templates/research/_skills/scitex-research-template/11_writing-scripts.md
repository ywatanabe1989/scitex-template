<!-- 11_writing-scripts.md -->

# Writing Experiment Scripts

Every analysis script should use the `@stx.session` decorator for
reproducibility and automatic output organization.

## Minimal skeleton

```python
#!/usr/bin/env python3
# File: scripts/my_experiment/01_analyze.py

import scitex as stx

@stx.session(seed=42)
def main(
    # Parameters auto-expose as CLI flags
    n_samples=1000,        # --n_samples 1000
    learning_rate=0.01,    # --learning_rate 0.01
    # Injected objects (do NOT pass manually)
    CONFIG=stx.INJECTED,   # Session metadata
    plt=stx.INJECTED,      # Pre-configured matplotlib
    logger=stx.INJECTED,   # Auto file-logging
):
    """Docstring becomes --help text."""
    stx.io.save(results, "results.csv")

    fig, ax = plt.subplots()
    ax.plot(x, y)
    stx.io.save(fig, "plot.png")    # also exports plot.csv

    # Centralize via symlink
    stx.io.save(
        data, "data/my_experiment/output.npy",
        symlink_to="../../data/my_experiment/",
    )
    return 0

if __name__ == "__main__":
    main()
```

## Output layout

A successful run produces:

```
scripts/my_experiment/01_analyze_out/FINISHED_SUCCESS/<session_id>/
├── logs/{stdout,stderr}.log
├── CONFIGS/CONFIG.yaml       # Full reproducibility record
└── <your outputs>
```

## Adding a new experiment

1. `mkdir scripts/my_experiment`
2. `cp scripts/template.py scripts/my_experiment/01_preprocess.py`
3. Number scripts by execution order: `01_`, `02_`, `03_`, …
4. Optional `main.sh`:

```bash
#!/bin/bash
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
python "$DIR/01_preprocess.py" "$@"
python "$DIR/02_train.py" "$@"
python "$DIR/03_evaluate.py" "$@"
```

5. Optional Makefile target:

```makefile
run-my-experiment:
	bash scripts/my_experiment/main.sh
```

## Conventions recap

- `@stx.session(seed=…)` on every experiment entrypoint
- `stx.io.save / load` for all file I/O (30+ formats, auto-mkdir)
- `symlink_to=` for centralized `data/` provenance
- Script name is `NN_description.py`; tests mirror under `tests/`
