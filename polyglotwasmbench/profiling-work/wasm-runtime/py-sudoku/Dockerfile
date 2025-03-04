FROM scratch
COPY sudoku.py sudoku.py
COPY rustpython.wasm rustpython.wasm
COPY input-64.txt input-64.txt
CMD ["rustpython.wasm", "./sudoku.py", "input-64.txt"]

