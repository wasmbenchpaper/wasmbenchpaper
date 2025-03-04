FROM scratch
#WORKDIR /app
COPY public public
#ENV WASMTIME_BACKTRACE_DETAILS=1
#ENV LISTEN_FDS=1
COPY fileserver.wasm fileserver.wasm
CMD ["./fileserver.wasm", "0.0.0.0", "8080", "./public"]
