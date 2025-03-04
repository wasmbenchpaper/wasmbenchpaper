FROM ubuntu
COPY --from=us.icr.io/polyglotwasmbench/sdk-wrapper-buildstage-time /root/.wasmedge/lib /root/.wasmedge/lib
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/.wasmedge/lib
COPY wrapper wrapper
COPY main.wasm main.wasm
COPY move2kube.mp4 move2kube.mp4
CMD ["./wrapper", "./main.wasm", "move2kube.mp4", "move2kube_copy.mp4"]

