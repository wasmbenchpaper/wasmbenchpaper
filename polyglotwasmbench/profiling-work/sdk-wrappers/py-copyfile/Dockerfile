FROM python:3.9
RUN pip install wasmtime
COPY wrapper.py wrapper.py
COPY main.wasm main.wasm
COPY move2kube.mp4 move2kube.mp4
CMD ["python", "./wrapper.py", "./main.wasm", "move2kube.mp4", "move2kube_copy.mp4"]

