WASI_VERSION=19
WASI_VERSION_FULL=${WASI_VERSION}.0
WASI_SDK_PATH=./t1/wasi-sdk-${WASI_VERSION_FULL}

install-wasi-sdk:
	bash -x install.sh

docker:
	docker run --rm -it -v "${PWD}:/src" -w /src ghcr.io/webassembly/wasi-sdk bash

build-wasm:
	${WASI_SDK_PATH}/bin/clang --sysroot=${WASI_SDK_PATH}/share/wasi-sysroot/ main.c -o main.wasm

run-wasm:
	wasmtime run --tcplisten 127.0.0.1:8080 main.wasm
