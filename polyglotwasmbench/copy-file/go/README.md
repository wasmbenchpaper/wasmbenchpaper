# Copy a file

## Usage

```console
$ go build main.go
$ ./main path/to/src path/to/dest
```

## Compile and run with WASM

```
$ tinygo build -wasm-abi=generic -target=wasi -o main.wasm main.go
$ wasmtime --dir=. main.wasm path/to/src path/to/dest
```
