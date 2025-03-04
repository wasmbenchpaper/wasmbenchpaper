# Sudoku benchmark

## Input file

The file input-64.txt contains the sudoku boards to be solved. Each line is a separate Sudoku board.

### Format

Example:
```
.6....9.2...92.....8..4..1....1....3......291......46.2.43.8...3....4...1.......5
```

The 81 squares (9 rows and 9 columns) of a Sudoku board are flattened into a single line
by going left to right and top to bottom (row by row). The dots represent blank squares.

## Python

Using the RustPython interpreter with WasmTime (warning: very slow)

```console
$ wasmtime --dir=. rustpython.wasm python/sudoku.py input-64.txt 
```

You can also use the WAPM package and run with Wasmer (slightly faster)

```console
$ wapm install python
$ wapm run --dir=. python -- python/sudoku.py input-64.txt
```
