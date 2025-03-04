# Create Charts/Graphs

## Prerequisites

Make sure you are using Python 3.11 or higher using something like https://github.com/pyenv/pyenv or https://python-poetry.org/

Create a virtual environment and install the dependencies.

```shell
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Run

Activate the virtual environment.

```shell
python3 create_charts.py --input-json ./perf_data.json
```

The output directory will contain the graphs.
