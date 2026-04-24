# SciTeX Cloud Module Template

A standalone template for developing custom SciTeX Cloud workspace modules.

## Quick Start

```bash
# 1. Use this template on GitHub (or clone it)
git clone https://github.com/ywatanabe1989/scitex-template-cloud-module.git my-module
cd my-module

# 2. Install dependencies
pip install -r requirements.txt

# 3. Edit your module
#    - module.py     → Your module logic (@stx.module decorated)
#    - manifest.yaml → Metadata (label, icon, category)

# 4. Preview locally
cd devserver && python manage.py runserver
# Open http://localhost:8000
```

## Structure

| File | Purpose |
|------|---------|
| `module.py` | Main module code with `@stx.module` decorator |
| `manifest.yaml` | Module metadata (name, icon, category, version) |
| `requirements.txt` | Python package dependencies |
| `tests/test_module.py` | Basic smoke tests |
| `devserver/` | Local preview server (same rendering as SciTeX Cloud) |

## Local Development

The `devserver/` directory contains a minimal Django app that runs your module
and renders outputs identically to SciTeX Cloud:

```bash
cd devserver
python manage.py runserver
```

Open `http://localhost:8000` to see your module's output. Edit `module.py`,
refresh the browser, and iterate.

## Module API

```python
import scitex as stx

@stx.module(
    label="My Module",
    icon="fa-puzzle-piece",
    category="utility",
    description="A custom SciTeX module.",
)
def main(project=stx.module.INJECTED, plt=stx.module.INJECTED):
    # Output text
    stx.module.output("Hello!", title="Greeting")

    # Output figures
    fig, ax = plt.subplots()
    ax.plot([1, 2, 3], [1, 4, 2])
    stx.module.output(fig, title="My Plot")

    # Output tables (pandas DataFrame)
    stx.module.output(df, title="Results")

    # Output HTML
    stx.module.output(stx.module.html("<b>Bold</b>"), title="Custom HTML")

    return 0
```

## Import into SciTeX Cloud

1. Push this repo to GitHub
2. In SciTeX Cloud, go to **Module Maker**
3. Click **Import from GitHub**
4. Paste your repository URL

## License

MIT
