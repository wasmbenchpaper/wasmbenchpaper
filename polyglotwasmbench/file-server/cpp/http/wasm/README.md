# HTTP file server for WASI/WASM

The directory to serve can be provided at runtime. See the Makefile for the exact command.

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
    $ make run-wasm
    ```
1. Then go to http://localhost:8080 in a browser.
