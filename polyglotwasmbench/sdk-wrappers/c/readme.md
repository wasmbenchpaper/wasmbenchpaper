# Instructions for [C SDK](https://wasmedge.org/book/en/sdk/c.html) wrapper

## Building the wrapper using wasmedge sdk

Download WasmEdge

```console
curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash
source $HOME/.wasmedge/env
```

Build the wrapper

```console
gcc embed.c -lwasmedge -o cembed
```

## Building the wrapper using wasmtime sdk

not supported

## Using wrapper for [copy-file](../../copy-file/cpp) project

Build the wasm module following the instructions in the copyfile for rust.

Note: The location where the binary is present is copied to wasm module for use.

```console
./cembed copy.wasm path/to/file/to/be/copied path/to/be/written
```

## Using wrapper for [sort](../../sort/cpp/) project

Build the wasm module following the instructions in the sort for cpp.

Note: The location where the binary is present is copied to wasm module for use.

```console
./cembed sort.wasm
```
