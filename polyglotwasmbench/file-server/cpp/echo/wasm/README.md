# TCP echo server for WASI/WASM

## Steps to build

1. Install the WASI SDK
    ```console
    $ make install-wasi-sdk
    ```
1. Start a container with the required build environment
    ```console
    $ make docker
    ```
1. Build the wasm module
    ```console
    $ make build-wasm
    ```

## Steps to run

1. Exit out of the container and run using WasmTime
    ```console
    $ wasmtime run --tcplisten 127.0.0.1:<port-number> main.wasm
    ```
1. Then on another terminal use netcat to connect to the server
    ```console
    $ nc localhost <port-number>
    ```
