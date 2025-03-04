# Rust version of Sudoku benchmark

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
    $ ./target/release/sudoku ../input-64.txt 
    got the args ["./target/release/sudoku", "../input-64.txt"]
    reading the file at path '../input-64.txt'
    [info] read file: 44757 ns
    [info] sudoku: 404217290 ns
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
1. Go to the parent directory so we can access the input file
    ```
    $ cd ..
    ```
1. To run in Wasmer runtime
    ```console
    $ wasmer run --dir=. rust/target/wasm32-wasi/release/sudoku.wasm -- input-64.txt 
    got the args ["sudoku.wasm", "input-64.txt"]
    reading the file at path 'input-64.txt'
    [info] read file: 189000 ns
    [info] sudoku: 647798000 ns
    ```

For more info, see https://github.com/bytecodealliance/wasmtime/blob/main/docs/WASI-tutorial.md#from-rust