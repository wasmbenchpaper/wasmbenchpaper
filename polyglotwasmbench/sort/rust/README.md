# Rust version of Sort benchmark

## Steps to run

1. Install Rust and Cargo https://www.rust-lang.org/tools/install
1. To compile and run in debug mode
    ```console
    $ cargo run
    ```
1. To compile in release mode
    ```console
    $ cargo build --release
    ```
1. To run the release binary
    ```
    $ ./target/release/sort
    [info] permute: 2323992589 ns
    [info] gen_array: 2324057124 ns
    [info] sort: 13890659656 ns
    ```

## Steps to run as WASM

1. Install WASI as a target we can compile to
    ```console
    $ rustup target add wasm32-wasi
    ```
1. To compile to WASM in release mode
    ```console
    $ cargo build --release --target wasm32-wasi
    ```
1. To run in Wasmer runtime
    ```console
    $ wasmer target/wasm32-wasi/release/sort.wasm 
    [info] permute: 1668496000 ns
    [info] gen_array: 1668620000 ns
    [info] sort: 12073736000 ns
    ```

For more info, see https://github.com/bytecodealliance/wasmtime/blob/main/docs/WASI-tutorial.md#from-rust