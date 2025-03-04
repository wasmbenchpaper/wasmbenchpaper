# TCP echo server for native execution (no wasm)

## Steps to build

To build the project:
```console
$ make build
```

Then:
```console
$ ./main <port-number>
```

Then on another terminal:
```console
$ nc localhost <port-number>
```
