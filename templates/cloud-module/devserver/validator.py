#!/usr/bin/env python3
"""Module validator — checks module.py and manifest.yaml for correctness."""

import ast
from pathlib import Path
from typing import List

import yaml

REQUIRED_MANIFEST_FIELDS = {"name", "label", "category"}
ALLOWED_CATEGORIES = {
    "utility",
    "analysis",
    "visualization",
    "statistics",
    "preprocessing",
    "io",
    "reporting",
    "machine-learning",
    "custom",
}


def validate_module(module_path: Path, manifest_path: Path = None) -> List[str]:
    """Validate a SciTeX module and its manifest.

    Returns a list of error messages. Empty list means valid.
    """
    errors = []

    # 1. Module file exists
    if not module_path.exists():
        errors.append(f"Module file not found: {module_path}")
        return errors

    source = module_path.read_text(encoding="utf-8")

    # 2. Has @stx.module decorator (AST check)
    try:
        tree = ast.parse(source, filename=str(module_path))
    except SyntaxError as e:
        errors.append(f"Syntax error in {module_path.name}: {e}")
        return errors

    has_decorator = False
    decorated_func = None
    for node in ast.walk(tree):
        if isinstance(node, ast.FunctionDef) and node.decorator_list:
            for dec in node.decorator_list:
                dec_name = _get_decorator_name(dec)
                if dec_name and "module" in dec_name:
                    has_decorator = True
                    decorated_func = node
                    break

    if not has_decorator:
        errors.append(
            "No @stx.module or @scitex.module decorator found. "
            "Module must have a decorated entry point."
        )

    # 3. Decorated function has expected parameters
    if decorated_func:
        param_names = [arg.arg for arg in decorated_func.args.args]
        if "project" not in param_names:
            errors.append(
                f"Function '{decorated_func.name}' should accept a 'project' parameter "
                "(injectable via stx.module.INJECTED)."
            )
        if "plt" not in param_names:
            errors.append(
                f"Function '{decorated_func.name}' should accept a 'plt' parameter "
                "(injectable via stx.module.INJECTED)."
            )

    # 4. Manifest validation
    if manifest_path is None:
        manifest_path = module_path.parent / "manifest.yaml"

    if not manifest_path.exists():
        errors.append(f"Manifest file not found: {manifest_path}")
        return errors

    try:
        manifest = yaml.safe_load(manifest_path.read_text(encoding="utf-8"))
    except yaml.YAMLError as e:
        errors.append(f"Invalid YAML in manifest: {e}")
        return errors

    if not isinstance(manifest, dict):
        errors.append("Manifest must be a YAML mapping (dict).")
        return errors

    # 5. Required fields
    for field in REQUIRED_MANIFEST_FIELDS:
        if field not in manifest:
            errors.append(f"Manifest missing required field: '{field}'")

    # 6. Category validation
    category = manifest.get("category", "")
    if category and category not in ALLOWED_CATEGORIES:
        errors.append(
            f"Invalid category '{category}'. "
            f"Allowed: {', '.join(sorted(ALLOWED_CATEGORIES))}"
        )

    return errors


def _get_decorator_name(node) -> str:
    """Extract decorator name as string from AST node."""
    if isinstance(node, ast.Call):
        return _get_decorator_name(node.func)
    if isinstance(node, ast.Attribute):
        parent = _get_decorator_name(node.value)
        return f"{parent}.{node.attr}" if parent else node.attr
    if isinstance(node, ast.Name):
        return node.id
    return ""


def _cli():
    """CLI entry point for module validation."""
    import sys

    module_path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("module.py")
    errors = validate_module(module_path)
    if errors:
        for e in errors:
            print(f"  ERROR: {e}")
        sys.exit(1)
    print("Module is valid.")


if __name__ == "__main__":
    _cli()
