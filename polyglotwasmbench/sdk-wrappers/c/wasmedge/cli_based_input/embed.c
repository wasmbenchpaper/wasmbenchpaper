#include <wasmedge/wasmedge.h>
#include <stdio.h>
#include <time.h>

static long time_diff(struct timespec start, struct timespec end) {
	time_t sec = end.tv_sec - start.tv_sec;
	long nano = end.tv_nsec - start.tv_nsec;
	return (long) sec * 1000 * 1000 * 1000 + nano;
}

int main(int Argc, const char* Argv[]) {
  /* Create the configure context and add the WASI support. */
  /* This step is not necessary unless you need WASI support. */
  WasmEdge_ConfigureContext *ConfCxt = WasmEdge_ConfigureCreate();
  WasmEdge_ConfigureAddHostRegistration(ConfCxt, WasmEdge_HostRegistration_Wasi);
  /* The configure and store context to the VM creation can be NULL. */
  WasmEdge_VMContext *VMCxt = WasmEdge_VMCreate(ConfCxt, NULL);
  WasmEdge_ModuleInstanceContext *wasi_module = WasmEdge_VMGetImportModuleContext (VMCxt, WasmEdge_HostRegistration_Wasi);
  const char *Dirs[1] = { ".:." };
  uint32_t argn = 0;
  uint32_t envn = 0;
  for (char *const *arg = Argv; *arg != NULL; ++arg, ++argn);
  extern char **environ;
  for (char *const *env = environ; *env != NULL; ++env, ++envn);


  WasmEdge_ModuleInstanceInitWASI(wasi_module, (const char *const *) &Argv[1], argn-1, (const char *const *) &environ[0], envn, Dirs, 1);
  /* The parameters and returns arrays. */
  // WasmEdge_Value Params[1] = { WasmEdge_ValueGenI32(32) };
  // WasmEdge_Value Returns[1];
  /* Function name. */
  struct timespec t0, t1;
  clock_gettime(CLOCK_MONOTONIC, &t0);

  WasmEdge_Result result = WasmEdge_VMRunWasmFromFile(VMCxt, Argv[1], WasmEdge_StringCreateByCString("_start"), NULL, 0, NULL, 0);

  clock_gettime(CLOCK_MONOTONIC, &t1);
  printf("[info] C wasmedge-sdk time taken: %ld ns\n", time_diff(t0, t1));

  // WasmEdge_String FuncName = WasmEdge_StringCreateByCString("main");
  // /* Run the WASM function from file. */
  // WasmEdge_Result Res = WasmEdge_VMRunWasmFromFile(VMCxt, Argv[1], FuncName, Argv, 1, Returns, 1);

  if (WasmEdge_ResultOK(result)) {
    // printf("Get result: \n");
  } else {
    printf("Error message: \n");
  }

  /* Resources deallocations. */
  WasmEdge_VMDelete(VMCxt);
  WasmEdge_ConfigureDelete(ConfCxt);
  // WasmEdge_StringDelete(FuncName);
  return 0;
}
