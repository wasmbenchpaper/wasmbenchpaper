#!/usr/bin/env bash

WASI_VERSION=19
WASI_VERSION_FULL="${WASI_VERSION}.0"
WASI_SDK_URL="https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_VERSION}/wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz"
mkdir -p t1/ && cd t1/ && wget "$WASI_SDK_URL" && tar -xzf "wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz"
