# Instructions for [Rust SDK](https://wasmedge.org/book/en/sdk/rust.html) wrapper

## Build the wrapper using wasmedge

Install [WasmEdge](https://wasmedge.org/book/en/quick_start/install.html) library on your local system.

```console
curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash
```

Build the wrapper

```console
$ cargo build --release
```

```console
$ ls
Cargo.lock   Cargo.toml   src  target
```

## Build the wrapper using wasmtime

TODO

## Using wrapper for [sort](../../sort/rust/) project

Build the wasm module following the instructions in the sort for rust.

Note: The location where the binary is present is copied to wasm module for use.

```console
$ ./target/release/embed_rust sort.wasm
```

## Using wrapper for [copy-file](../../copy-file/go/) project

Build the wasm module following the instructions in the copyfile for rust.

Note: The location where the binary is present is copied to wasm module for use.

```console
./target/release/embed_rust copy.wasm path/to/file/to/be/copied path/to/be/written
```