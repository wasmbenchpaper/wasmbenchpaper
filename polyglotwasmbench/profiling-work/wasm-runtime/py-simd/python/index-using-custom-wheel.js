const { loadPyodide } = require('pyodide');
const fs = require('fs');

const pythonFilePath = 'main.py';
const pythonSIMDFilePath = 'main-simd.py';
const pythonCode = fs.readFileSync(pythonFilePath).toString();
const pythonSIMDCode = fs.readFileSync(pythonSIMDFilePath).toString();

async function main() {
    //console.log('main start');
    const envs = process.env;
    // //console.log('running with envs', envs);
    const run_with_simd = envs['WITH_SIMD'] === 'true';
    const num_rows = parseInt(envs['NUM_ROWS']) || 64;
    const num_cols = parseInt(envs['NUM_COLS']) || 128;
    const num_iters = parseInt(envs['NUM_ITERS']) || 100;
    //console.log('run_with_simd', run_with_simd, 'num_rows', num_rows, 'num_cols', num_cols, 'num_iters', num_iters);
    const pyodide = await loadPyodide({});
    //console.log('loading the numpy package');
    // await pyodide.loadPackage("numpy");
    await pyodide.loadPackage('./numpy-0.1.0_alpha.1.mybuild-cp310-cp310-emscripten_3_1_27_wasm32.whl');
    pyodide.globals.set('NUM_ROWS', num_rows);
    pyodide.globals.set('NUM_COLS', num_cols);
    pyodide.globals.set('NUM_ITERS', num_iters);
    const code = run_with_simd ? pythonSIMDCode : pythonCode;
    //console.log(`running the python code:\n-------------------\n${code}\n-------------------`);
    pyodide.runPython(code);
    //console.log('main end');
}

main().catch(console.error);
