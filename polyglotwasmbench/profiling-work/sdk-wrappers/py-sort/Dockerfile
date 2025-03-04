FROM python:3.9
RUN pip install wasmtime
COPY wrapper.py wrapper.py
COPY main.wasm main.wasm
CMD ["python", "./wrapper.py", "./main.wasm"]

