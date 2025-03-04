use std::env;
use std::time::Instant;
use wasmedge_sdk::{
    config::{CommonConfigOptions, ConfigBuilder, HostRegistrationConfigOptions},
    params, Vm,
};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let config = ConfigBuilder::new(CommonConfigOptions::default())
        .with_host_registration_config(HostRegistrationConfigOptions::default().wasi(true))
        .build()?;

    let mut vm = Vm::new(Some(config))?;
    let dir_mapping = ".:.";

    // let args = vec!["arg1", "arg2"];
    let args: Vec<String> = env::args().collect();
    let mut args_slice: Vec<&str> = args.iter().map(|s| &**s).collect();
    let envs = vec!["ENV1=VAL1", "ENV2=VAL2", "ENV3=VAL3"];
    let mut wasi_module = vm.wasi_module()?;
    wasi_module.initialize(Some(args_slice.drain(1..).collect()), Some(envs),  Some(vec![dir_mapping]));

    assert_eq!(wasi_module.exit_code(), 0);

    let start_instant = Instant::now();
    vm.run_func_from_file(&args[1], "_start", params!())?;
    println!("[info] Rust wasmedge-sdk time taken: {} ns", start_instant.elapsed().as_nanos());
    Ok(())
}
