FROM ubuntu
COPY --from=us.icr.io/polyglotwasmbench/sdk-wrapper-buildstage-time /root/.wasmedge/lib /root/.wasmedge/lib
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/.wasmedge/lib
COPY wrapper wrapper
COPY main.wasm main.wasm
COPY graph-250000-edges.txt graph-250000-edges.txt
CMD ["./wrapper", "./main.wasm", "graph-250000-edges.txt"]

