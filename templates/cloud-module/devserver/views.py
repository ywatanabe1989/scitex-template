"""Preview view — runs module.py and renders outputs."""

import traceback
from pathlib import Path

from django.shortcuts import render

MODULE_PATH = Path(__file__).resolve().parent.parent / "module.py"
PROJECT_PATH = Path(__file__).resolve().parent.parent
OUTPUT_DIR = Path(__file__).resolve().parent / ".output"


MANIFEST_PATH = MODULE_PATH.parent / "manifest.yaml"


def preview(request):
    """Validate, then execute the module and render its output cards."""
    OUTPUT_DIR.mkdir(exist_ok=True)

    # Validate first
    from .validator import validate_module

    validation_errors = validate_module(MODULE_PATH, MANIFEST_PATH)
    if validation_errors:
        return render(
            request,
            "preview.html",
            {
                "manifest": {},
                "outputs": [],
                "error": "Validation errors:\n"
                + "\n".join(f"  - {e}" for e in validation_errors),
                "module_path": str(MODULE_PATH),
            },
        )

    try:
        from scitex_cloud.module._runner import run_module

        result = run_module(MODULE_PATH, PROJECT_PATH, OUTPUT_DIR)
    except Exception:
        result = {
            "manifest": {},
            "outputs": [],
            "error": traceback.format_exc(),
        }

    manifest = result.get("manifest", {})
    outputs = result.get("outputs", [])
    error = result.get("error", "")

    return render(
        request,
        "preview.html",
        {
            "manifest": manifest,
            "outputs": outputs,
            "error": error,
            "module_path": str(MODULE_PATH),
        },
    )
