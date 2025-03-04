# Rust Server Examples for native exection (no wasm)

## Steps to build

```console
$ make build
```

## Steps to run

### TCP echo server

1. Run the wasm module
    ```console
    $ make run-echo
    ```
1. Then on another terminal use netcat to connect to the server
    ```
    $ nc 127.0.0.1 8080
    ```

### HTTP server

1. Run the wasm module
    ```console
    $ make run-http
    ```
1. Then go to http://localhost:8080 in a browser.
