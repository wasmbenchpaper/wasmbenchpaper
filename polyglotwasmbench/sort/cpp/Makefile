# OM NAMO GANAPATHAYEN NAMAHA
# .PHONY: all clean

# all: sort.c
# 	$(CCWASI) sort.c -o sort.wasm

# clean:
# 	rm sort.o

# WASI_VERSION=19
# WASI_VERSION_FULL=${WASI_VERSION}.0
# WASI_SDK_PATH=./t1/wasi-sdk-${WASI_VERSION_FULL}
# WASI_SDK_URL="https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_VERSION}/wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz"

install-wasi-sdk:
	bash -x install.sh

build-wasm:
	${WASI_SDK_PATH}/bin/clang --sysroot=${WASI_SDK_PATH}/share/wasi-sysroot/ sort.c -o main.wasm
