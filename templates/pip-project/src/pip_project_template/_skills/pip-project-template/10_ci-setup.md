<!-- 10_ci-setup.md -->

# CI Setup — Baked-in GitHub Actions

Two workflows ship under `.github/workflows/`:

## `validation.yml`

Triggered on push to `develop`/`main` and on PRs targeting `develop`.
Steps:

1. Checkout + Python 3.11 setup
2. `pip install -e ".[dev]"`
3. `ruff check src/` — linting
4. Test suite (typically `pytest` with coverage)

Adjust the Python version matrix and the install command to match the
dependency extras you keep in `pyproject.toml`.

## `notification.yml`

Triggered by `workflow_run` completion of the Validation workflow.
Sends a Slack notification via `8398a7/action-slack@v3`.

### Required secrets

| Secret | Purpose |
|---|---|
| `SLACK_WEBHOOK_URL` | Incoming-webhook URL for your team channel |

If you do not use Slack, delete `notification.yml` entirely; nothing
else in the template depends on it.

## Local dry-run with `act`

See `tests/github_actions/` for a pre-configured `act` runner (uses
Singularity/Apptainer). Lets you validate workflow YAML changes before
pushing.

## Publishing to PyPI

The template does **not** ship a publish workflow. Add one (typical
`pypa/gh-action-pypi-publish` via trusted-publisher/OIDC) when you are
ready to release.
