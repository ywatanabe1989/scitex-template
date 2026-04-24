<!-- 01_quick-start.md -->

# Quick Start — Bootstrap a Research Project

## 1. Create the project

Preferred route — via the SciTeX CLI:

```bash
scitex template clone research ./my_project
cd my_project
```

Alternative — clone directly:

```bash
git clone https://github.com/ywatanabe1989/scitex-research-template.git my_project
cd my_project
```

## 2. Install

```bash
pip install scitex        # if not already installed
make install              # project dependencies
make setup                # full setup (install + verification)
```

Requires Python ≥3.10 and scitex ≥2.0.0.

## 3. Run the MNIST example

```bash
make run-mnist
```

This exercises the full pipeline: data download, preprocessing,
training, evaluation, and figure generation. Outputs land in
`scripts/mnist/*_out/FINISHED_SUCCESS/<session_id>/`.

## 4. Clean the example and start your own work

```bash
make clean-mnist          # remove the MNIST pipeline
cp scripts/template.py scripts/my_experiment/01_analyze.py
```

See [02_structure.md](02_structure.md) for the layout and
[11_writing-scripts.md](11_writing-scripts.md) for the `@stx.session`
pattern every script should follow.

## 5. Add a manuscript (optional)

```bash
make setup-writer
# or
scitex writer clone scitex/writer/my_paper
```

LaTeX manuscripts live under `scitex/writer/` and share resources
(title, authors, bibliography) across `00_shared/`, `01_manuscript/`,
`02_supplementary/`, `03_revision/`.

## 6. Day-to-day

```bash
make check                # format + lint + test (run before committing)
make test                 # tests only
make format               # ruff format + shfmt
make lint                 # ruff check
```
