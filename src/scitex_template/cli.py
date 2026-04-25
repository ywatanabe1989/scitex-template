"""CLI for scitex-template.

Subcommands follow the noun-verb convention (general/03_interface_02_cli):

    scitex-template list                    # list registered templates
    scitex-template info <id>               # show one template
    scitex-template clone <id> <target>     # populate target from cache
    scitex-template cache-refresh           # force re-clone of monorepo cache
    scitex-template version                 # print version
"""

from __future__ import annotations

import sys
from pathlib import Path

import click


def _version() -> str:
    try:
        from importlib.metadata import version

        return version("scitex-template")
    except Exception:  # pragma: no cover
        return "unknown"


@click.group(context_settings={"help_option_names": ["-h", "--help"]})
@click.version_option(_version(), "-V", "--version")
def main() -> None:
    """scitex-template — clone scitex-* project templates from the monorepo cache."""


@main.command("list")
@click.option(
    "--json",
    "as_json",
    is_flag=True,
    help="Output as JSON instead of a human-readable table.",
)
def list_cmd(as_json: bool) -> None:
    """List all registered templates."""
    from .registry import load_registry

    entries = load_registry()
    if as_json:
        import json as _json

        click.echo(
            _json.dumps(
                [
                    {
                        "id": e.id,
                        "version": e.version,
                        "description": e.description,
                        "path": str(e.path),
                    }
                    for e in entries
                ],
                indent=2,
            )
        )
        return

    width = max((len(e.id) for e in entries), default=12)
    for e in entries:
        click.echo(f"  {e.id:<{width}}  v{e.version}  {e.description}")


@main.command("info")
@click.argument("template_id")
def info_cmd(template_id: str) -> None:
    """Print details for a single template."""
    from .registry import find_template

    e = find_template(template_id)
    if e is None:
        click.echo(f"unknown template id: {template_id}", err=True)
        sys.exit(1)
    click.echo(f"id          : {e.id}")
    click.echo(f"version     : {e.version}")
    click.echo(f"description : {e.description}")
    click.echo(f"path        : {e.path}")


@main.command("clone")
@click.argument("template_id")
@click.argument("target", type=click.Path(path_type=Path))
@click.option(
    "--force-refresh",
    is_flag=True,
    help="Wipe and re-clone the monorepo cache before populating target.",
)
@click.option(
    "--branch",
    default="main",
    show_default=True,
    help="Branch of the scitex-template monorepo to track in the cache.",
)
def clone_cmd(template_id: str, target: Path, force_refresh: bool, branch: str) -> None:
    """Populate TARGET with the contents of TEMPLATE_ID."""
    from ._cache import clone_template_from_cache

    try:
        out = clone_template_from_cache(
            template_id, target, branch=branch, force_refresh=force_refresh
        )
    except KeyError as e:
        click.echo(str(e), err=True)
        sys.exit(1)
    except FileExistsError as e:
        click.echo(str(e), err=True)
        sys.exit(2)
    click.echo(f"cloned {template_id} → {out}")


@main.command("cache-refresh")
@click.option("--branch", default="main", show_default=True)
def cache_refresh_cmd(branch: str) -> None:
    """Force-refresh the ~/.scitex/template/cache/ shallow clone."""
    from ._cache import ensure_cache

    root = ensure_cache(branch=branch, force_refresh=True)
    click.echo(f"refreshed cache at {root}")


@main.command("version")
def version_cmd() -> None:
    """Print version (same as -V)."""
    click.echo(_version())


if __name__ == "__main__":
    main()
