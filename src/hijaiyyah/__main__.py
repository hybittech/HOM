"""Entry point: python -m hijaiyyah"""


def main() -> None:
    """Launch the HOM GUI application."""
    from .gui.app import HOMApp

    app = HOMApp()
    app.run()


if __name__ == "__main__":
    main()
