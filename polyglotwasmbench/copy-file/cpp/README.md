# Copy a file

## Usage

1. Compile the code
    ```console
    $ make build
    ```
1. Run the binary
    ```console
    $ ./main path/to/src path/to/dest
    ```

## Compile and run with WASM

1. Install the WASI SDK
    ```console
    $ make install-wasi-sdk
    ```
1. Start a docker container with the development environment
    ```console
    $ make docker
    ```
1. Compile the code to WASI/WASM
    ```console
    $ make build-wasm
    ```
1. Exit the Docker container. Now we can run the compiled WASM module
    ```console
    $ wasmtime run --dir=. main.wasm path/to/src path/to/dest
    ```
