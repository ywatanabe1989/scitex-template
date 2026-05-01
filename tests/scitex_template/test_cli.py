"""Tests for scitex_template.cli."""

import json

import pytest
from click.testing import CliRunner

from scitex_template.cli import main


@pytest.fixture
def runner():
    return CliRunner()


class TestList:
    def test_human_output(self, runner):
        result = runner.invoke(main, ["list"])
        assert result.exit_code == 0
        for tid in (
            "pip-project",
            "minimal",
            "cloud-module",
            "research",
            "singularity",
            "paper",
        ):
            assert tid in result.output

    def test_json_output(self, runner):
        result = runner.invoke(main, ["list", "--json"])
        assert result.exit_code == 0
        data = json.loads(result.output)
        ids = {row["id"] for row in data}
        assert {"pip-project", "research"}.issubset(ids)


class TestInfo:
    def test_known_id(self, runner):
        result = runner.invoke(main, ["info", "pip-project"])
        assert result.exit_code == 0
        assert "pip-project" in result.output
        assert "version" in result.output.lower() or "0.1.0" in result.output

    def test_unknown_id(self, runner):
        result = runner.invoke(main, ["info", "does-not-exist"])
        assert result.exit_code == 1


class TestVersion:
    def test_v_flag(self, runner):
        result = runner.invoke(main, ["-V"])
        assert result.exit_code == 0
        # accept any of: a real version string, or "unknown"
        assert result.output.strip()
