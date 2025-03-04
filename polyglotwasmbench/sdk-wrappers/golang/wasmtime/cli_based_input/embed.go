package main

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
	"time"

	"github.com/bytecodealliance/wasmtime-go"
)

func run_wasm() {
	engine_cfg := wasmtime.NewConfig()
	linker := wasmtime.NewLinker(wasmtime.NewEngineWithConfig(engine_cfg))
	linker.DefineWasi()
	go_module, err := wasmtime.NewModuleFromFile(linker.Engine, os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	config := wasmtime.NewWasiConfig()
	config.SetArgv(os.Args[1:])
	config.PreopenDir(".", ".")
	dir, err := os.MkdirTemp("", "out")
	if err != nil {
		log.Fatal(err)
	}
	defer os.RemoveAll(dir)
	stdoutPath := filepath.Join(dir, "stdout")
	config.SetStdoutFile(stdoutPath)
	store := wasmtime.NewStore(linker.Engine)
	store.SetWasi(config)
	instance, err := linker.Instantiate(store, go_module)
	if err != nil {
		log.Fatal(err)
	}
	start := instance.GetFunc(store, "_start")
	// fmt.Printf("%+v", start[0])
	var t0 time.Time = time.Now()
	_, err = start.Call(store)
	if err != nil {
		log.Fatal(err)
	}
	var t1 time.Time = time.Now()
	fmt.Printf("[info] Golang wasmtime-sdk time taken: %v ns\n", t1.Sub(t0).Nanoseconds())

	// Print WASM stdout
	_, err = os.ReadFile(stdoutPath)
	if err != nil {
		log.Fatal(err)
	}
	// fmt.Print(string(out))
}

func main() {
	run_wasm()
}
