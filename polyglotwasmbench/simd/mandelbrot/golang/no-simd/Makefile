BIN_DIR=build
BIN_NAME=mandelbrot-no-simd.wasm

clean:
	rm -rf ${BIN_DIR}

build:
	mkdir -p ${BIN_DIR}
	tinygo build -wasm-abi=generic -target=wasi -o ${BIN_DIR}/${BIN_NAME} main.go

run:
	wasmtime build/mandelbrot-no-simd.wasm
