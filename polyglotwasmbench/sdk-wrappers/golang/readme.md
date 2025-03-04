# Instructions for [Go SDK](https://wasmedge.org/book/en/sdk/go.html) wrapper

## Building the wrapper using wasmedge

Download `WasmEdge-go` extension.
Note: The WasmEdge-go requires golang version >= 1.16. Please check your golang version before installation.

Download `WasmEdge` shared library which is of same version of `WasmEdge-go`.

```console
curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash -s -- -v 0.11.2
```

Building the wrapper

```console
go mod init
go get
go build
```

## Building the wrapper using wasmtime

No other external dependencies.

Building the wrapper

```console
go mod init
go get
go build
```

Note: preopen socket is not supported by golang sdk.

## Using wrapper for [copy-file](../../copy-file/go/) project

Build the wasm module following the instructions in the copyfile for rust.

Note: The location where the binary is present is copied to wasm module for use.

```console
./embed_go copy.wasm path/to/file/to/be/copied path/to/be/written
```

## Using wrapper for [sort](../../sort/go/) project

Build the wasm module following the instructions in the sort for go.

Note: The location where the binary is present is copied to wasm module for use.

```console
./cembed sort.wasm
```
