use std::env;
use std::fs;
use std::io::ErrorKind;
use std::path;
use std::process;
use std::time::Instant;

fn main() {
    // let start_instant = Instant::now();
    let args: Vec<String> = env::args().collect();
    // println!("running with args: {:?}", args);
    if args.len() != 3 {
        println!("usage: copy path/to/src/file path/to/dest/file/or/folder");
        process::exit(1);
    }
    let input_path = args[1].to_owned();
    let _output_path = args[2].to_owned();
    // println!("copying");
    // let t0 = start_instant.elapsed().as_nanos();
    let output_path: String = match fs::metadata(_output_path.as_str()) {
        Ok(x) => {
            if x.is_dir() {
                let src_filename: String = String::from(
                    path::Path::new(&input_path)
                        .file_name()
                        .unwrap()
                        .to_str()
                        .unwrap(),
                );
                [_output_path, src_filename].join(path::MAIN_SEPARATOR.to_string().as_str())
            } else {
                _output_path.to_owned()
            }
        }
        Err(e) => match e.kind() {
            ErrorKind::NotFound => _output_path.to_owned(),
            _ => {
                println!("failed to stat the destination path. error: {}", e);
                process::exit(1);
            }
        },
    };
    match fs::copy(input_path, output_path) {
        Ok(_) => (),
        Err(e) => {
            println!("failed to copy. error: {}", e);
            process::exit(1);
        }
    };
    // let t1 = start_instant.elapsed().as_nanos();
    // println!("[info] copy done in: {} ns\n", t1 - t0);
}
