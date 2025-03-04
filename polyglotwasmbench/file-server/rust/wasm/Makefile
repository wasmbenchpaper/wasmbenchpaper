build:
	${RUST_BIN_PATH}cargo build --release --target wasm32-wasi

run-echo:
	wasmtime run --tcplisten 127.0.0.1:8080 --env 'LISTEN_FDS=1' target/wasm32-wasi/release/wasi-server-echo.wasm

run-http:
	wasmtime run --tcplisten 127.0.0.1:8080 --dir=. --env 'LISTEN_FDS=1' target/wasm32-wasi/release/wasi-server-http.wasm 127.0.0.1 8080 ./public
