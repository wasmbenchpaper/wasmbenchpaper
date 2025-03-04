//! Example of instantiating a wasm module which uses WASI imports.

/*
You can execute this example with:
    cmake example/
    cargo run --example wasi
*/

use anyhow::Result;
use wasmtime::*;
use std::time::Instant;
use wasmtime_wasi::sync::WasiCtxBuilder;
use std::{env, os::fd::FromRawFd};
use wasmtime_wasi::sync::TcpListener as Tl;
use std::net::{TcpListener};
use libc;

fn opendirr() -> i32{
    unsafe {
    let pathcstring = std::ffi::CString::new(".").unwrap();
    let l = libc::open(pathcstring.as_ptr(), libc::O_RDONLY);
    return l;
    }
}

fn main() -> Result<()> {
    // Define the WASI functions globally on the `Config`.
    let my_fd = opendirr();
    let engine = Engine::default();
    let mut linker = Linker::new(&engine);
    wasmtime_wasi::add_to_linker(&mut linker, |s| s)?;
    let args: Vec<String> = env::args().collect();
    // Create a WASI context and put it in a Store; all instances in the store
    // share this context. `WasiCtxBuilder` provides a number of ways to
    // configure what the target program will have access to.
    // let dir = std::fs::File::open(".").unwrap();
    let tcp_listener = TcpListener::bind("0.0.0.0:8080").unwrap();
    let tcp_listener_2 = Tl::from_std(tcp_listener);
    let socket = wasmtime_wasi::net::Socket::from(tcp_listener_2);
    unsafe {
    // use std::time::Instant;
    let dirfd = wasmtime_wasi::Dir::from_raw_fd(my_fd);
    let wasi = WasiCtxBuilder::new()
        .inherit_stdio()
        .preopened_socket(3, socket).unwrap()
        .preopened_dir(dirfd, ".").unwrap()
        .args(&args[1..])?
        .build();
    let mut store = Store::new(&engine, wasi);
    
    let tt = Instant::now();

    // Instantiate our module with the imports we've created, and run it.
    let module = Module::from_file(&engine, &args[1])?;
    linker.module(&mut store, "", &module)?;
    linker
        .get_default(&mut store, "")?
        .typed::<(), ()>(&store)?
        .call(&mut store, ())?;
    println!("[info] Rust wasmtime-sdk time taken: {} ns", tt.elapsed().as_nanos());
    }
    Ok(())
}



// use anyhow::Result;
// use wasmtime::*;
// use wasmtime_wasi::sync::WasiCtxBuilder;
// use std::{env, os::fd::FromRawFd};
// use wasmtime_wasi::sync::TcpListener as Tl;
// use std::net::{TcpListener};


// fn main() -> Result<()> {
//     // Define the WASI functions globally on the `Config`.
//     let engine = Engine::default();
//     let mut linker = Linker::new(&engine);
//     wasmtime_wasi::add_to_linker(&mut linker, |s| s)?;
//     let args: Vec<String> = env::args().collect();
//     // Create a WASI context and put it in a Store; all instances in the store
//     // share this context. `WasiCtxBuilder` provides a number of ways to
//     // configure what the target program will have access to.
//     let dir = std::fs::File::open(".").unwrap();
//     let tcp_listener = TcpListener::bind("127.0.0.1:3000").unwrap();
//     let tcp_listener_2 = Tl::from_std(tcp_listener);
//     let socket = wasmtime_wasi::net::Socket::from(tcp_listener_2);
//     let wasi = WasiCtxBuilder::new()
//         .inherit_stdio()
//         .preopened_socket(3, socket).unwrap()
//         // .preopened_dir(wasmtime_wasi::Dir::from_raw_fd(fd), ".").unwrap()
//         .args(&args[1..])?
//         .build();
//     let mut store = Store::new(&engine, wasi);

//     // Instantiate our module with the imports we've created, and run it.
//     let module = Module::from_file(&engine, "./wasi-server-echo.wasm")?;
//     linker.module(&mut store, "", &module)?;
//     linker
//         .get_default(&mut store, "")?
//         .typed::<(), ()>(&store)?
//         .call(&mut store, ())?;

//     Ok(())
// }
