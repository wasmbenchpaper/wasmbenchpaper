FROM python:3.9
RUN pip install wasmtime
COPY wrapper.py wrapper.py
COPY graph-250000-edges.txt graph-250000-edges.txt
CMD ["python", "./wrapper.py", "./main.wasm", "graph-250000-edges.txt"]

