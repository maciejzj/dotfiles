c.TerminalIPythonApp.display_banner = False

c.TerminalInteractiveShell.shortcuts = [
    {'command': 'IPython:shortcuts.open_input_in_editor', 'new_keys': ['c-x', 'c-e']},
]

c.InteractiveShellApp.extensions = ['autoreload']

c.InteractiveShellApp.exec_lines = ['%autoreload 2']

c.InteractiveShellApp.exec_lines = [
    'from pathlib import Path',

    'import numpy as np',
    'import pandas as pd',
    'import skimage',
    'from matplotlib import pyplot as plt',
    'from plotly import express as ex',
]
