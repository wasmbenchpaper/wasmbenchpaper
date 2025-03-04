package main

import (
	"fmt"
	"os"
	"time"

	"github.com/second-state/WasmEdge-go/wasmedge"
)

func main() {
	wasmedge.SetLogErrorLevel()

	var conf = wasmedge.NewConfigure(wasmedge.REFERENCE_TYPES)
	conf.AddConfig(wasmedge.WASI)
	var vm = wasmedge.NewVMWithConfig(conf)
	var wasi = vm.GetImportModule(wasmedge.WASI)
	wasi.InitWasi(
		os.Args[1:],     // The args
		os.Environ(),    // The envs
		[]string{".:."}, // The mapping directories
	)

	var t0 time.Time = time.Now()
	// Instantiate wasm. _start refers to the main() function
	vm.RunWasmFile(os.Args[1], "_start")
	var t1 time.Time = time.Now()
	fmt.Printf("[info] Golang wasmedge-sdk time taken: %v ns\n", t1.Sub(t0).Nanoseconds())

	vm.Release()
	conf.Release()
}
