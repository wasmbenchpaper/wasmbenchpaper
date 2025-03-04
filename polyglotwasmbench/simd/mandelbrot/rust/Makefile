clean:
	cargo clean

build:
	cargo build --release --target wasm32-wasi

run:
	wasmtime --dir=. ./target/wasm32-wasi/release/mandelbrot-simd-bitmap.wasm
