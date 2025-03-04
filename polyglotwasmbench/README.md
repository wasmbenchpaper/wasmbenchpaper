# Webassembly Benchmark Paper

## Mounting a directory

For both Wasmer and WasmTime use the `--dir` flag to mount a directory.
Example that mounts the current directory:
- Wasmer
    ```console
    $ wasmer run --dir=. myapp.wasm 
    ```
- WasmTime
    ```console
    $ wasmtime run --dir=. myapp.wasm 
    ```

## Steps to compile to WASM

### Rust

1. Install Rust and Cargo https://www.rust-lang.org/tools/install
1. Install WASI as a target we can compile to
    ```console
    $ rustup target add wasm32-wasi
    ```
1. To compile to WASM in release mode
    ```console
    $ cargo build --release --target wasm32-wasi
    ```
1. To run in Wasmer runtime
    ```console
    $ wasmer target/wasm32-wasi/release/myapp.wasm 
    ```

Also see https://enarx.dev/docs/WebAssembly/Rust

### Python

1. Install WAPM https://wapm.io/
1. Install the Python package https://wapm.io/python/python
    ```console
    $ wapm install python/python
    ```
1. Run the Python package (uses Wasmer runtime)
    ```console
    $ wapm run --dir=. python -- path/to/myapp.py
    ```

Alternative https://wapm.io/rustpython/rustpython
Also see https://enarx.dev/docs/WebAssembly/Python

### Golang

1. Install TinyGo https://tinygo.org/getting-started/install/
1. Compile to WASM/WASI target with TinyGo
    ```console
    $ tinygo build -wasm-abi=generic -target=wasi -o main.wasm main.go
    ```

Also see https://enarx.dev/docs/WebAssembly/Golang

### C/C++

1. Install the WASI-SDK
    ```console
    export WASI_VERSION=14
    export WASI_VERSION_FULL=${WASI_VERSION}.0
    wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_VERSION}/wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz
    tar xvf wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz
    ```
1. Compile to WASI/WASM target with `clang`
    ```console
    $ export WASI_SDK_PATH=`pwd`/wasi-sdk-${WASI_VERSION_FULL}
    $ CC="${WASI_SDK_PATH}/bin/clang --sysroot=${WASI_SDK_PATH}/share/wasi-sysroot"
    $ $CC foo.c -o foo.wasm
    ```

See https://github.com/WebAssembly/wasi-sdk#use

Alternative https://developer.mozilla.org/en-US/docs/WebAssembly/C_to_wasm
and https://emscripten.org/docs/getting_started/Tutorial.html

Also see https://enarx.dev/docs/WebAssembly/C++

### other way 

#### Dependencies

Install emsdk
```
git clone --depth 1 https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
```

#### Code to WASM

```
emcc -g -Oz --llvm-lto 1 -s STANDALONE_WASM -s INITIAL_MEMORY=32MB -s MAXIMUM_MEMORY=4GB \
  -mmutable-globals \
  -mnontrapping-fptoint \
  -msign-ext \
  sort.c -o sort.wasm
```

#### Run with wasmer

```
wasmer run sort.wasm
```

### Building a web-assembly container image
Build the image from the wasm using the below command and dockerfile:
```
buildah bud --annotation "module.wasm.image/variant=compat" -t sort-wasm .
```
```
FROM scratch
WORKDIR /app
COPY /cpp/sort.wasm /app/sort.wasm
ENTRYPOINT [ "/app/sort.wasm" ]
```
Re-tag the image
```
buildah tag localhost/sort-wasm localhost/sort-wasm us.icr.io/polyglotwasmbench/sort-wasm
```
Pusing the image
```
podman push us.icr.io/polyglotwasmbench/sort-wasm:latest
```
### Profiling the execution web-assembly container
```
sudo perf record podman run --runtime /usr/local/bin/crun-wasm us.icr.io/polyglotwasmbench/sort-wasm:latest
```
```
sudo syscount -c podman run --runtime /usr/local/bin/crun-wasm us.icr.io/polyglotwasmbench/sort-wasm:latest
```
```
sudo perf stat podman run --runtime /usr/local/bin/crun-wasm us.icr.io/polyglotwasmbench/sort-wasm:latest
```

## How to use buildandpush.sh

Build and push builder and runner images. Runner image uses builder image as base and **only runner image should be used for profiling.**

*Note: Please feel free to modify image `REGISTRY` and `NAMESPACE` variables in the shell script.*

### Usage

```
bash buildandpush.sh wrapper_language runtime wasm_language project_name
```

### Example

```
bash buildandpush.sh py wasmtime rust sort
```

Builder image `us.icr.io/polyglotwasmbench/bench_py_wasmtime_wrapper_rust_sort` and Runner image `us.icr.io/polyglotwasmbench/bench_py_wasmtime_wrapper_rust_sort_runner` would be available.

For profiling usage you can simply do similar to below command.

```
docker run us.icr.io/polyglotwasmbench/bench_py_wasmtime_wrapper_rust_sort_runner
```