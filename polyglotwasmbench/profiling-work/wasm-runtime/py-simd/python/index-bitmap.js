const { loadPyodide } = require('pyodide');
const fs = require('fs');

// const pythonFilePath = 'main.py';
// const pythonSIMDFilePath = 'main-simd.py';
const pythonBitmapFilePath = 'main-bitmap-2.py';
const pythonBitmapSIMDFilePath = 'main-bitmap-simd.py';
// const pythonCode = fs.readFileSync(pythonFilePath).toString();
// const pythonSIMDCode = fs.readFileSync(pythonSIMDFilePath).toString();
const pythonBitmapCode = fs.readFileSync(pythonBitmapFilePath).toString();
const pythonBitmapSIMDode = fs.readFileSync(pythonBitmapSIMDFilePath).toString();

async function main() {
    //console.log('main start');
    const envs = process.env;
    // //console.log('running with envs', envs);
    const run_with_simd = envs['WITH_SIMD'] === 'true';
    const num_rows = parseInt(envs['NUM_ROWS']) || 256;
    const num_cols = parseInt(envs['NUM_COLS']) || 256;
    const num_iters = parseInt(envs['NUM_ITERS']) || 100;
    const output_path = envs['MY_OUTPUT_FILE'] || './mandelbrot.pbm';
    //console.log('run_with_simd', run_with_simd, 'num_rows', num_rows, 'num_cols', num_cols, 'num_iters', num_iters, 'output_path', output_path);
    const pyodide = await loadPyodide({
        args: ['mandelbrot', `${num_cols}`, `${num_rows}`, `${num_iters}`],
    });
    //console.log('loading the numpy package');
    // await pyodide.loadPackage("numpy");
    await pyodide.loadPackage('./numpy-0.1.0_alpha.1.mybuild-cp310-cp310-emscripten_3_1_27_wasm32.whl');
    const code = run_with_simd ? pythonBitmapSIMDode : pythonBitmapCode;
    //console.log(`running the python code:\n-------------------\n${code}\n-------------------`);
    // pyodide.runPython(run_with_simd ? pythonSIMDCode : pythonCode);
    const result = pyodide.runPython(code).toJs();
    // //console.log('result', result);
    fs.writeFileSync(output_path, result);
    // const bitmap = pyodide.globals.get('bitmap').toJs();
    // //console.log('bitmap', bitmap);
    //console.log('main end');
}

main().catch(console.error);
