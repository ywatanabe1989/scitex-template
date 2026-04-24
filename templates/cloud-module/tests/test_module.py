#!/usr/bin/env python3
"""Tests for the SciTeX module template."""

from pathlib import Path

ROOT = Path(__file__).parent.parent


def test_module_has_decorator():
    """module.py should have @stx.module decorator."""
    source = (ROOT / "module.py").read_text()
    assert "@stx.module" in source


def test_manifest_exists():
    """manifest.yaml should exist."""
    assert (ROOT / "manifest.yaml").exists()


def test_manifest_has_required_fields():
    """manifest.yaml should have name, label, category."""
    import yaml

    manifest = yaml.safe_load((ROOT / "manifest.yaml").read_text())
    for field in ("name", "label", "category"):
        assert field in manifest, f"Missing field: {field}"


def test_validator_passes_on_template():
    """Validator should pass on the default template module."""
    from devserver.validator import validate_module

    errors = validate_module(ROOT / "module.py", ROOT / "manifest.yaml")
    assert errors == [], f"Unexpected errors: {errors}"


def test_validator_detects_missing_decorator():
    """Validator should detect missing @stx.module decorator."""
    import tempfile

    from devserver.validator import validate_module

    with tempfile.NamedTemporaryFile(mode="w", suffix=".py", delete=False) as f:
        f.write("def main():\n    pass\n")
        f.flush()
        errors = validate_module(Path(f.name), ROOT / "manifest.yaml")
    assert any("decorator" in e.lower() for e in errors)


def test_validator_detects_invalid_category():
    """Validator should reject invalid manifest category."""
    import tempfile

    import yaml

    from devserver.validator import validate_module

    bad_manifest = {"name": "test", "label": "Test", "category": "invalid-category"}
    with tempfile.NamedTemporaryFile(mode="w", suffix=".yaml", delete=False) as f:
        yaml.dump(bad_manifest, f)
        f.flush()
        errors = validate_module(ROOT / "module.py", Path(f.name))
    assert any("category" in e.lower() for e in errors)


def test_mock_project_creates_files():
    """Mock project generator should create sample data files."""
    import tempfile

    from devserver.mock_project import create_mock_project

    with tempfile.TemporaryDirectory() as tmpdir:
        project_dir = create_mock_project(Path(tmpdir) / "mock")
        assert (project_dir / "data" / "sample.csv").exists()
        assert (project_dir / "data" / "config.yaml").exists()
        assert (project_dir / "data" / "results.json").exists()
        assert (project_dir / "README.md").exists()
