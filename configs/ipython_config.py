from pathlib import Path


c.TerminalIPythonApp.display_banner = False

c.TerminalInteractiveShell.shortcuts = [
    {'command': 'IPython:shortcuts.open_input_in_editor', 'new_keys': ['c-x', 'c-e']},
]

c.InteractiveShellApp.extensions = ['autoreload']

c.InteractiveShellApp.exec_lines = ['%autoreload 2']

import_script_path = Path(__file__).parent / 'ipython_imports.py'
c.InteractiveShellApp.exec_files = [str(import_script_path)]
