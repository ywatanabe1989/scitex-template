<!-- ---
!-- Timestamp: 2026-02-24 17:36:27
!-- Author: ywatanabe
!-- File: /home/ywatanabe/.dotfiles/src/.claude/to_claude/commands/scitex-versions.md
!-- --- -->

# SciTeX Versions Management

## Overview
Manage and sync versions across the SciTeX ecosystem packages on local and remote hosts.

## Dashboard
Check this first:
scitex dev versions list --json
http://127.0.0.1:5000

## Ecosystem Packages (in order)
01. scitex (scitex-python)
02. scitex-cloud
03. figrecipe
04. openalex-local
05. crossref-local
06. scitex-writer
07. scitex-dataset
08. socialia
09. automated-research-demo
10. scitex-research-template
11. pip-project-template
12. singularity-template
... and being cumulated


## PyPI Trusted Publisher

Configure github action in this pattern

``` bash
Repository: ywatanabe1989/figrecipe
Workflow: publish-pypi.yml
Environment name: pypi
```

## Commands

### List versions (read-only)
```bash
scitex dev versions list                         # Local + PyPI versions
scitex dev versions list --json                  # JSON output
scitex dev versions list -p scitex               # Specific package
scitex dev versions list --local-only            # Skip PyPI
scitex dev versions list-hosts                   # SSH host versions
scitex dev versions list-hosts --host nas        # Specific host
scitex dev versions list-remotes                 # GitHub remote versions
scitex dev versions list-rtd                     # Read the Docs status
scitex dev versions check                        # Consistency check
scitex dev versions dashboard                    # Start dashboard GUI
```

### Sync (safe — preview by default, --confirm to execute)
```bash
# Remote host sync
scitex dev versions sync                             # Preview (dry run)
scitex dev versions sync --confirm                   # Execute (parallel)
scitex dev versions sync --confirm --host nas        # Sync specific host
scitex dev versions sync --confirm -p scitex         # Sync specific package
scitex dev versions sync --confirm --no-install      # Git pull only

# Local install
scitex dev versions sync --local                     # Preview local install
scitex dev versions sync --local --confirm           # Execute local install

# Tag push
scitex dev versions sync --tags                      # Preview tag push
scitex dev versions sync --tags --confirm            # Execute tag push
```

### MCP Tools
```
mcp__scitex__dev_versions_list
mcp__scitex__dev_versions_sync        # confirm=False → preview, confirm=True → execute
mcp__scitex__dev_versions_sync_local  # confirm=False → preview, confirm=True → execute
mcp__scitex__dev_config_show
mcp__scitex__dev_bulk_rename          # confirm=False → preview, confirm=True → execute
mcp__scitex__dev_test_local
mcp__scitex__dev_test_hpc
mcp__scitex__dev_test_hpc_poll
mcp__scitex__dev_test_hpc_result
```

### Python API
```python
from scitex._dev import sync_all, sync_local, sync_tags

# Preview (safe default)
preview = sync_all()                          # dry run
preview = sync_local()                        # dry run

# Execute (requires confirm=True)
results = sync_all(confirm=True)              # parallel across hosts
results = sync_all(hosts=["nas"], confirm=True)
results = sync_local(confirm=True)
results = sync_tags(confirm=True)
```

## Workflow: Update All Packages

### Quick sync (recommended)
```bash
# 1. Preview what will happen
scitex dev versions sync
scitex dev versions sync --local

# 2. Execute
scitex dev versions sync --confirm
scitex dev versions sync --local --confirm

# 3. Verify
scitex dev versions list
```

### Manual workflow (if needed)
```bash
# Push changes to origin
for repo in scitex-python scitex-cloud figrecipe openalex-local crossref-local scitex-writer scitex-dataset socialia; do
    cd ~/proj/$repo && git push origin develop 2>/dev/null || git push origin main
done

# Verify
scitex dev versions list
```

## Version Increment Workflow

### 0. Major, minor, and patch

We use version in the form of vX.Y.Z, where

X is Major
Y is Minor
Z is Patch and may have -alpha, -beta suffix

When increment version, check the difference and determine if it is minor or patch. No major update please as long as user explicitly requests.

### 1. Update version in pyproject.toml
```bash
# Edit pyproject.toml: version = "X.Y.Z"
```

### 2. Commit and tag
```bash
git add pyproject.toml
git commit -m "chore: bump version to X.Y.Z"
git tag -a vX.Y.Z -m "Release vX.Y.Z"
git push origin develop --tags
```

### 3. Sync to all hosts
```bash
scitex dev versions sync --tags --confirm
scitex dev versions sync --confirm
```

## Tag Syncing

### Fix tag not reachable from current branch
When `git describe --tags` shows an older tag because the latest tag is on a different branch (e.g., main vs develop):
```bash
cd ~/proj/PACKAGE
git tag -d vX.Y.Z                           # Delete local tag
git tag -a vX.Y.Z -m "Release vX.Y.Z" HEAD  # Retag on current HEAD
git push origin vX.Y.Z --force               # Force-push updated tag
```

### Sync all tags from remote
```bash
cd ~/proj/PACKAGE && git fetch --tags
```

### Push all local tags to remote
```bash
cd ~/proj/PACKAGE && git push origin --tags
```

### List tags sorted by version
```bash
cd ~/proj/PACKAGE && git tag --sort=-v:refname | head -10
```

## Environment Paths
- **Local (WSL)**: `~/.env-3.11/bin/activate`
- **NAS**: `~/.venv-3.11/bin/activate`
- **Spartan**: `~/python3.11/bin/python3.11` (no venv, user-local install)

## Troubleshooting

### Merge conflicts on NAS/Spartan
**WARNING: Only use `git reset --hard` as a last resort — it discards all local changes.**
Prefer `git stash` first to preserve any in-progress work:
```bash
# Safe approach: stash, pull, then re-apply
ssh nas "cd ~/proj/PACKAGE && git stash && git checkout develop && git pull && git stash pop"
ssh spartan "cd ~/proj/PACKAGE && git stash && git checkout develop && git pull && git stash pop"

# Nuclear option (DESTROYS local changes — confirm before running):
# ssh nas "cd ~/proj/PACKAGE && git reset --hard HEAD && git clean -fd && git checkout develop && git pull"
```

### Check installed version
```bash
pip show PACKAGE | grep Version
```

### Stale dist-info directories
If `importlib.metadata` reports wrong version (e.g., old version instead of current):
```bash
# Find all dist-info for the package
ls ~/.env-3.11/lib/python3.11/site-packages/PACKAGE_NAME-*.dist-info
# Remove stale ones (keep only the current version)
rm -rf ~/.env-3.11/lib/python3.11/site-packages/PACKAGE_NAME-OLD_VERSION.dist-info
```

<!-- EOF -->