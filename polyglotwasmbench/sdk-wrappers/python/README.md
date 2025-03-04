# Instructions for Python sdk-wrapper

## Build the wrapper using wasmtime

Download `WasmTime` pip package

```
pip install wasmtime
```

Note: wasmtime python sdk does not support preopen_socket.

## Build the wrapper using wasmedge

No supported.

## Using wrapper for [copy-file](../../copy-file/go/) project

Build the wasm module following the instructions in the copyfile for rust.

Note: The location where the binary is present is copied to wasm module for use.

```console
python embed.py copy.wasm path/to/file/to/be/copied path/to/be/written
```

## Using wrapper for [sort](../../sort/go/) project

Build the wasm module following the instructions in the sort for go.

Note: The location where the binary is present is copied to wasm module for use.

```console
python embed.py sort.wasm
```
