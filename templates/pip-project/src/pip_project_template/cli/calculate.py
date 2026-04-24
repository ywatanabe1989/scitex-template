#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Timestamp: "2025-08-31 08:11:10 (ywatanabe)"
# File: /home/ywatanabe/proj/pip-project-template/src/pip_project_template/cli/calculate.py
# ----------------------------------------
from __future__ import annotations
import os
__FILE__ = (
    "./src/pip_project_template/cli/calculate.py"
)
__DIR__ = os.path.dirname(__FILE__)
# ----------------------------------------

# NOTE THAT THIS IS AN EXAMPLE BOILERPLATE SCRIPT CREATED IN PIP PROJECT TEMPLATE PROJECT.
# PLEASE REMOVE OR UPDATE TO FIT YOUR PROJECT.

"""Calculate command."""

import argparse


def create_parser():
    """Create parser for calculate command."""
    parser = argparse.ArgumentParser(
        description="Perform calculations", add_help=False
    )
    parser.add_argument("a", type=float, help="First number")
    parser.add_argument("b", type=float, help="Second number")
    parser.add_argument(
        "--operation",
        choices=["add", "multiply"],
        default="add",
        help="Operation to perform",
    )
    return parser


def main(args=None):
    """Execute calculate command."""
    parser = create_parser()
    parsed = parser.parse_args(args)

    from ..core._Calculator import Calculator

    calc = Calculator()
    result = calc.calculate(parsed.a, parsed.b, parsed.operation)
    print(f"{parsed.a} {parsed.operation} {parsed.b} = {result}")
    return 0

# EOF
