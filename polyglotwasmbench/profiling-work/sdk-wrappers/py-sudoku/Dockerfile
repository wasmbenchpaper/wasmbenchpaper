FROM python:3.9
RUN pip install wasmtime
COPY wrapper.py wrapper.py
COPY main.wasm main.wasm
COPY input-64.txt input-64.txt
CMD ["python", "./wrapper.py", "./main.wasm", "./input-64.txt"]

