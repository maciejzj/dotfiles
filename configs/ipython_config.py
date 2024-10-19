from pathlib import Path

# Extensions
c.InteractiveShellApp.extensions = ["autoreload"]
c.InteractiveShellApp.exec_lines = ["%autoreload 2"]

# UI and colorscheme
c.TerminalIPythonApp.display_banner = False
c.TerminalInteractiveShell.true_color = True
c.TerminalInteractiveShell.highlighting_style = "catppuccin-mocha"

# Keybindings
c.TerminalInteractiveShell.shortcuts = [
    {
        "command": "IPython:shortcuts.open_input_in_editor",
        "new_keys": ["c-x", "c-e"]
    },
]

# Always import
import_script_path = Path(__file__).parent / "ipython_imports.py"
c.InteractiveShellApp.exec_files = [str(import_script_path)]
