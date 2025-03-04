## WASM-WASI and Native

### Dependencies

Install emcc
```
git clone --depth 1 https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
```

Install WasmEdge
```
curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash
source $HOME/.wasmedge/env
```

### Compile code to wasm
Compile mandelbrot set code to wasm
```
emcc -g -Oz --llvm-lto 1 -s STANDALONE_WASM -s INITIAL_MEMORY=32MB -s MAXIMUM_MEMORY=4GB \
  -mmutable-globals \
  -mnontrapping-fptoint \
  -msign-ext \
  mandelbrot_set.c -o mandelbrot_set.wasm
```

Compile mandelbrot set with smid code (with SIMD) to wasm
```
emcc -g -Oz --llvm-lto 1 -s STANDALONE_WASM -s INITIAL_MEMORY=32MB -s MAXIMUM_MEMORY=4GB \
  -mmutable-globals \
  -mnontrapping-fptoint \
  -msign-ext \
  mandelbrot_set_with_simd.c -o mandelbrot_set_with_simd.wasm
```

### Compile code to C object code

Compile mandelbrot set code to c object code
```
gcc mandelbrot_set_with_simd.c -pipe -Wall -O3 -ffast-math -fno-finite-math-only -march=native -mfpmath=sse -msse3 -o mandelbrot_set_with_simd.o
```

Compile mandelbrot set with smid code (with SIMD) to c object code
```
gcc mandelbrot_set.c -pipe -Wall -O3 -ffast-math -fno-finite-math-only -march=native -mfpmath=sse -msse3 -o mandelbrot_set.o
```

### Run with WasmEdge

#### Interpretor Mode

With SIMD
```
wasmedge mandelbrot_set_with_simd.wasm 4000
```

Without SIMD
```
wasmedge mandelbrot_set.wasm 4000
```

#### Ahead-of-Time mode

With SIMD

Compile wasm-simd with wasmedge aot compiler
```
wasmedgec mandelbrot_set_with_simd.wasm mandelbrot_set_with_simd-out.wasm
```

Run the native binary with wasmedge
```
wasmedge mandelbrot_set_with_simd-out.wasm 4000
```

Without SIMD

Compile wasm-simd with wasmedge aot compiler
```
wasmedgec mandelbrot_set.wasm mandelbrot_set-out.wasm
```

Run the native binary with wasmedge
```
wasmedge mandelbrot_set-out.wasm 4000
```

**First Cut Observation using `time` command :**

higher is better (used wasmedge with AOT compilation)
`native simd > native without simd > wasm simd > wasm without simd`

without AOT
`native simd > native without simd >> wasm simd > wasm without simd`