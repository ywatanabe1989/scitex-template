<!-- 02_structure.md -->

# Directory Structure

```
my_project/
├── config/              # YAML configuration (PATH.yaml, experiment YAMLs)
├── data/                # Centralized data access (symlinks from script outputs)
├── scripts/             # Main workspace for analysis
│   ├── mnist/           # Example pipeline (remove via `make clean-mnist`)
│   └── template.py      # Starting point for new scripts
├── tests/               # Mirrors scripts/ layout
├── scitex/              # SciTeX-managed resources (see table below)
├── management/          # Git-tracked project management (meeting notes, decisions)
├── GITIGNORED/          # Untracked working files (drafts, scratch, AI logs)
├── externals/           # External dependencies / vendored code
├── docs/                # Documentation
└── Makefile             # install / setup / run-mnist / check / test
```

## SciTeX sub-directories

| Directory            | Purpose                                           | Setup                                           |
|----------------------|---------------------------------------------------|-------------------------------------------------|
| `scitex/writer/`     | LaTeX manuscripts (00_shared, 01_manuscript, …)   | `make setup-writer` (cloned on demand)          |
| `scitex/scholar/`    | Bibliography (.bib) + PDF library                 | `scitex scholar add paper.pdf`                  |
| `scitex/vis/`        | Figure management, gallery templates              | `scitex vis import path/to/fig.png`             |
| `scitex/code/`       | Code templates and AI-assisted coding prompts     | Automatic                                       |
| `scitex/ai/`         | Centralized AI prompts (symlinks)                 | Automatic                                       |
| `scitex/uploads/`    | File staging area                                 | Automatic                                       |

## `management/` vs `GITIGNORED/`

| Aspect      | `management/`                       | `GITIGNORED/`                            |
|-------------|-------------------------------------|------------------------------------------|
| Git tracked | Yes                                 | No                                       |
| Purpose     | Shared project artifacts            | Personal working files                   |
| Contents    | Meeting notes, decisions, setup     | Drafts, scratch data, AI conversations   |
| Audience    | Team (via git)                      | Individual (local only)                  |

## Symlink architecture

Script outputs under `scripts/<name>/<name>_out/` are symlinked into
`data/` using the `symlink_to=` argument to `stx.io.save`. This keeps
per-script provenance while giving the rest of the project a flat,
centralized `data/` view.

Note: the legacy root-level `_skills/SKILL.md` is being migrated —
`CLAUDE.md` marks `_skills/` deprecated in favor of `.claude/skills/`
for runtime agent skills. This template-authoring skill under
`_skills/scitex-research-template/` is the release-time source for the
package skill, per the SciTeX skills quality checklist.
