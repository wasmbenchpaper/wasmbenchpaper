build:
	g++ -std=c++17 main.cpp -o main

run:
	./main main.cpp foo.cpp && ls

docker:
	docker run --rm -it -v "${PWD}:/src" -w /src ghcr.io/webassembly/wasi-sdk bash

install-wasi-sdk:
	bash -x install.sh

# build-wasm:
# 	./t1/wasi-sdk-14.0/bin/clang++ --sysroot=t1/wasi-sdk-14.0/share/wasi-sysroot/ main.cpp -o main.wasm

build-wasm:
	${WASI_SDK_PATH}/bin/clang++ --sysroot=${WASI_SDK_PATH}/share/wasi-sysroot/ main.cpp -o main.wasm
