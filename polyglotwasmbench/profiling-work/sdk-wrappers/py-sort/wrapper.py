from wasmtime import Config, Engine, Linker, Module, Store, WasiConfig
import os
import sys
import tempfile
import time


def run_wasm():
    engine_cfg = Config()
    engine_cfg.cache = True

    linker = Linker(Engine(engine_cfg))
    linker.define_wasi()

    python_module = Module.from_file(linker.engine, sys.argv[1])

    config = WasiConfig()

    config.argv = set(sys.argv[1:])
    config.preopen_dir(".", ".")

    with tempfile.TemporaryDirectory() as chroot:
        out_log = os.path.join(chroot, "out.log")
        err_log = os.path.join(chroot, "err.log")
        config.stdout_file = out_log
        config.stderr_file = err_log

        store = Store(linker.engine)

        store.set_wasi(config)
        instance = linker.instantiate(store, python_module)

        t0: float = time.time()
        start = instance.exports(store)["_start"]

        try:
            start(store)
        except Exception as e:
            print(e)
            raise

        t1: float = time.time()
        print("[info] Python wasmtime-sdk time taken: {} ns".format((t1 - t0) * 1e9))

        with open(out_log) as f:
            result = f.read()

        print(result)

        # with open(err_log) as f:
        #     result = f.read()

        # print(result)

if __name__ == "__main__":
    try:
        run_wasm()
    except Exception as e:
        print(e)