<!-- 01_quick-start.md -->

# Quick Start — Bootstrap a New Package

## 1. Clone

```bash
git clone https://github.com/ywatanabe1989/pip-project-template YOUR-PACKAGE-NAME
cd YOUR-PACKAGE-NAME
rm -rf .git           # double-check cwd first
git init && git add . && git commit -m "Initial commit from pip-project-template"
```

## 2. Rename placeholders

Two spellings must both be updated. Use the provided rename helper:

```bash
# Preview (no flag = dry-run)
./mgmt/utils/rename.sh pip-project-template YOUR-PACKAGE-NAME
./mgmt/utils/rename.sh pip_project_template YOUR_PACKAGE_NAME

# Apply (-n = execute)
./mgmt/utils/rename.sh pip-project-template YOUR-PACKAGE-NAME -n
./mgmt/utils/rename.sh pip_project_template YOUR_PACKAGE_NAME -n
```

The hyphenated form is the PyPI/distribution name, the underscored form
is the Python import name.

## 3. Update metadata

Edit `pyproject.toml`:

- `name`, `description`, `authors`, `maintainers`
- `dependencies` — drop what you do not need (FastMCP, pandas, etc.)
- `[project.urls]` — repo/issue URLs
- classifiers and keywords

Remove the `NOTE THAT THIS IS AN EXAMPLE BOILERPLATE…` banners from
Python files, configs, and docs.

## 4. Install and verify

```bash
python -m venv .env && source .env/bin/activate
make install           # editable install + dev deps
make test-full         # full test suite
```

## 5. Replace example code

Drop or rewrite:

- `src/<pkg>/core/` — example Calculator class
- `src/<pkg>/cli/` — Click CLI entrypoints
- `src/<pkg>/mcp_servers/` — FastMCP 2.0 servers (delete if not needed)
- `src/<pkg>/utils/`, `src/<pkg>/types/` — example utilities and types

Keep the test layout under `tests/<pkg>/` and mirror your new modules.

## 6. First release

Bump version in `pyproject.toml` and tag:

```bash
git tag v0.1.0 && git push --tags
# PyPI publish (configure the workflow or run manually):
python -m build && twine upload dist/*
```
