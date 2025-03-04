build:
	cargo build --release

run:
	./target/release/graph-recursive ../../com-youtube.ungraph.txt

run-smaller-graph:
	./target/release/graph-recursive ../../graph-250000-edges.txt

build-wasm:
	cargo build --release --target=wasm32-wasi

run-wasm:
	cd ../../ && ls && wasmtime --dir=. ./rust/graph_recursive/target/wasm32-wasi/release/graph-recursive.wasm ./graph-250000-edges.txt
