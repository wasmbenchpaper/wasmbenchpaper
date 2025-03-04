## Rust version of SIMD Mandelbrot Benchmark

Contains but non-simd and simd variants.

1. Build the WASM module
    ```console
    $ make build
    ```
1. Run the SIMD version of the WASM module
    ```console
    $ make run
    ```

## Compile to Native

For compiling to native binary, you have to comment out the line
```rust
#[target_feature(enable = "simd128")]
```
in both the files `src/simd/main.rs` and `src/simd-bitmap/main.rs`

Then you can run
```shell
$ cargo build --release
```

Note: VERY IMPORTANT - If you want to compile to Wasm again then remember to uncomment the lines again. If you leave the lines commented out then the Wasm binary will not have any SIMD instructions.