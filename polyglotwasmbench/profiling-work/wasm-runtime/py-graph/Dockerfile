FROM scratch
COPY graph.py graph.py
COPY rustpython.wasm rustpython.wasm
COPY graph-250000-edges.txt graph-250000-edges.txt
CMD ["rustpython.wasm", "./graph.py", "graph-250000-edges.txt"]

