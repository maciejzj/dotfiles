import atexit
import os
import readline

# Save python history to XDG compatible dir layout
if 'PYTHONHISTFILE' in os.environ:
    histfile = os.path.expanduser(os.environ['PYTHONHISTFILE'])
elif 'XDG_DATA_HOME' in os.environ:
    histfile = os.path.join(
        os.path.expanduser(os.environ['XDG_DATA_HOME']), 'python', 'python_history'
    )
else:
    histfile = os.path.join(os.path.expanduser('~'), '.python_history')

histfile = os.path.abspath(histfile)
_dir, _ = os.path.split(histfile)
os.makedirs(_dir, exist_ok=True)

try:
    readline.read_history_file(histfile)
    readline.set_history_length(10_000)
except FileNotFoundError:
    pass

atexit.register(readline.write_history_file, histfile)

# Often used packages
from matplotlib import pyplot as plt
import numpy as np
import pandas as pd
