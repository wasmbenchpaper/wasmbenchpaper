# Rust version of Graph Recursive benchmark

## Steps to run

1. Install Rust and Cargo https://www.rust-lang.org/tools/install
1. To compile in release mode
    ```console
    $ make build
    ```
1. To run the release binary
    ```console
    $ make run
    ./target/release/graph-recursive ../../com-youtube.ungraph.txt
    got the args ["./target/release/graph-recursive", "../../com-youtube.ungraph.txt"]
    reading the file at path '../../com-youtube.ungraph.txt'
    [info] read file: 23920901 ns
    [info] created the graph: 3019906103 ns
    [info] colored the graph: 14351020093 ns
    k = 36
    ```
1. To run the release binary on the smaller graph
    ```console
    $ make run-smaller-graph 
    ./target/release/graph-recursive ../../graph-250000-edges.txt
    got the args ["./target/release/graph-recursive", "../../graph-250000-edges.txt"]
    reading the file at path '../../graph-250000-edges.txt'
    [info] read file: 1488923 ns
    [info] created the graph: 188985708 ns
    [info] colored the graph: 1571439960 ns
    k = 25
    ```

## Steps to run as WASM

1. Install WASI as a target we can compile to
    ```console
    $ rustup target add wasm32-wasi
    ```
1. To compile to WASM in release mode
    ```console
    $ make build-wasm
    ```
1. To run in the WASM module. Note: Running with the full 3 million edges graph runs out of memory and call stack space.
    ```console
         2969: 0x527b - <unknown>!std::sys_common::backtrace::__rust_begin_short_backtrace::h7df9a4fdc865df3b
         2970: 0x51f5 - <unknown>!std::rt::lang_start::{{closure}}::hf6f10e18550f2bfe
         2971: 0x87e9 - <unknown>!std::rt::lang_start_internal::h06476437793b6eeb
         2972: 0x51c5 - <unknown>!__main_void
         2973:  0x5b1 - <unknown>!_start
       note: using the `WASMTIME_BACKTRACE_DETAILS=1` environment variable may show more debugging information
    2: wasm trap: call stack exhausted
    ```
    So we run with a smaller 250000 edge graph
    ```console
    $ make run-wasm 
    cd ../../ && ls && wasmtime --dir=. ./rust/graph_recursive/target/wasm32-wasi/release/graph-recursive.wasm ./graph-250000-edges.txt
    com-youtube.ungraph.txt  cpp  go  graph-250000-edges.txt  java	js  python  rust
    got the args ["graph-recursive.wasm", "./graph-250000-edges.txt"]
    reading the file at path './graph-250000-edges.txt'
    [info] read file: 2707895 ns
    [info] created the graph: 166137953 ns
    [info] colored the graph: 1588701282 ns
    k = 25
    ```

For more info, see https://github.com/bytecodealliance/wasmtime/blob/main/docs/WASI-tutorial.md#from-rust
