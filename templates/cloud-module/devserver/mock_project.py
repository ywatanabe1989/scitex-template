#!/usr/bin/env python3
"""Mock project generator for local module development.

Creates a temporary project directory with sample data files
so module authors can test their modules with realistic data.
"""

import csv
import json
from pathlib import Path


def create_mock_project(output_dir: Path = None) -> Path:
    """Create a mock project directory with sample data files.

    Parameters
    ----------
    output_dir : Path, optional
        Where to create the mock project. Defaults to devserver/.mock_project/

    Returns
    -------
    Path
        Path to the created mock project directory.
    """
    if output_dir is None:
        output_dir = Path(__file__).parent / ".mock_project"

    output_dir.mkdir(parents=True, exist_ok=True)

    # Sample CSV data
    data_dir = output_dir / "data"
    data_dir.mkdir(exist_ok=True)

    csv_path = data_dir / "sample.csv"
    with open(csv_path, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["x", "y", "group", "label"])
        for i in range(20):
            writer.writerow([i, i * 2.5 + (i % 3), "A" if i < 10 else "B", f"item_{i}"])

    # Sample config
    config_path = data_dir / "config.yaml"
    config_path.write_text(
        "# Project configuration\n"
        "name: mock-project\n"
        "version: 1.0.0\n"
        "parameters:\n"
        "  learning_rate: 0.001\n"
        "  epochs: 100\n"
        "  batch_size: 32\n",
        encoding="utf-8",
    )

    # Sample JSON results
    results_path = data_dir / "results.json"
    results_path.write_text(
        json.dumps(
            {
                "accuracy": 0.95,
                "loss": 0.12,
                "epochs_completed": 50,
                "best_epoch": 42,
            },
            indent=2,
        ),
        encoding="utf-8",
    )

    # README
    readme_path = output_dir / "README.md"
    readme_path.write_text(
        "# Mock Project\n\n"
        "This is a mock project for local module development.\n"
        "Files in `data/` are available via the `project` injectable.\n",
        encoding="utf-8",
    )

    return output_dir


if __name__ == "__main__":
    path = create_mock_project()
    print(f"Mock project created at: {path}")
