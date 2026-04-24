#!/usr/bin/env python3
"""Example SciTeX module — replace with your own logic."""

import scitex as stx


@stx.module(
    label="My Module",
    icon="fa-puzzle-piece",
    category="utility",
    description="A custom SciTeX module.",
)
def main(project=stx.module.INJECTED, plt=stx.module.INJECTED):
    """Main entry point for the module."""
    # --- Your module logic here ---

    stx.module.output("Hello from My Module!", title="Greeting")

    fig, ax = plt.subplots()
    ax.plot([1, 2, 3, 4], [1, 4, 2, 3])
    ax.set_xlabel("X")
    ax.set_ylabel("Y")
    stx.module.output(fig, title="Example Plot")

    return 0


if __name__ == "__main__":
    main()
