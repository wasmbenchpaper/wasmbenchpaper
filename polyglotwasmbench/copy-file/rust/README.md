# Copy a file

## Usage

```console
$ cargo build --release
$ ./target/release/copy path/to/src path/to/dest
```

## Compile and run with WASM

if using rustup
```
rustup target add  wasm32-wasi
```

```
$ cargo build --release --target=wasm32-wasi
$ wasmtime --dir=. target/wasm32-wasi/release/copy.wasm path/to/src path/to/dest
```
