use std::io::Read;
use std::os::wasi::prelude::FromRawFd;

use libc;
use tokio::io::{AsyncReadExt, AsyncWriteExt};
use tokio::net::{TcpListener, TcpStream};

const MY_DIR_FD: i32 = 4;

fn list_files_in_dir(sub_dir_path: &str) -> Option<Vec<String>> {
    // println!("try to list the files in the directory at fd 4");
    unsafe {
        let dir_path = std::ffi::CString::new(sub_dir_path).unwrap();
        let mydird = libc::openat(
            MY_DIR_FD,
            dir_path.as_ptr(),
            libc::O_DIRECTORY | libc::O_RDONLY,
        );
        if mydird < 0 {
            let t1 = std::ffi::CString::new("openat").unwrap();
            libc::perror(t1.as_ptr());
            panic!("failed to open the directory file descriptor 4. the returned fd is negative");
        }
        let dp = libc::fdopendir(mydird);
        if dp.is_null() {
            let t1 = std::ffi::CString::new("fdopendir").unwrap();
            libc::perror(t1.as_ptr());
            panic!("failed to open the sub directory file descriptor as a directory using fdopendir. the returned pointer is NULL");
        }
        let mut files: Vec<String> = Vec::new();
        loop {
            let x = libc::readdir(dp);
            if x.is_null() {
                break;
            }
            let name_ptr = (*x).d_name.as_ptr();
            let cfilename = std::ffi::CStr::from_ptr(name_ptr);
            let filename = cfilename.to_str().unwrap().to_owned();
            // println!("[debug] found a file: '{}'", filename);
            files.push(filename);
        }
        return Some(files);
    }
}

fn read_file_into_memory(file_path: &str) -> Option<Vec<u8>> {
    // println!(
    //     "[trace] read_file_into_memory called with file_path '{}'",
    //     file_path
    // );
    unsafe {
        let c_file_path = std::ffi::CString::new(file_path).unwrap();
        let myfiled = libc::openat(MY_DIR_FD, c_file_path.as_ptr(), libc::O_RDONLY);
        if myfiled < 0 {
            let t1 = std::ffi::CString::new("openat").unwrap();
            libc::perror(t1.as_ptr());
            println!("[error] failed to open the file using directory descriptor");
            return None;
        }

        let mut myfile = std::fs::File::from_raw_fd(myfiled);
        let mut file_contents = Vec::new();
        let num_bytes_read = match myfile.read_to_end(&mut file_contents) {
            Ok(x) => x,
            Err(e) => {
                println!("[error] failed to read the file completely. error: {}", e);
                return None;
            }
        };
        // println!("[info] read {} bytes from the file", num_bytes_read);
        return Some(file_contents);
    }
}

#[tokio::main(flavor = "current_thread")]

async fn main() -> std::io::Result<()> {
    let args: Vec<String> = std::env::args().collect();
    if args.len() != 4 {
        // println!("[info] usage: ./file_server <ip> <port> <directory>\n");
        return Err(std::io::Error::new(
            std::io::ErrorKind::InvalidInput,
            "invalid args",
        ));
    }
    let directory = args[3].to_owned();
    {
        let files = list_files_in_dir(&directory).unwrap();
        // println!("list of files in the directory: {:?}", files);
    }

    // Set up pre-established listening socket.
    let standard = unsafe { std::net::TcpListener::from_raw_fd(3) };
    standard.set_nonblocking(true).unwrap();
    let listener = TcpListener::from_std(standard)?;

    loop {
        // Accept new sockets in a loop.
        let socket = match listener.accept().await {
            Ok(s) => s.0,
            Err(e) => {
                eprintln!("> ERROR: {}", e);
                continue;
            }
        };

        // Spawn a background task for each new connection.
        let directory_copy = directory.to_owned();
        tokio::spawn(async move {
            eprintln!("> CONNECTED");
            match handle(socket, &directory_copy).await {
                Ok(()) => eprintln!("> DISCONNECTED"),
                Err(e) => eprintln!("> ERROR: {}", e),
            }
        });
    }
}

async fn handle(mut socket: TcpStream, directory: &str) -> std::io::Result<()> {
    loop {
        let mut buf = [0u8; 4096];

        // Read some bytes from the socket.
        let read = socket.read(&mut buf).await?;

        // Handle a clean disconnection.
        if read == 0 {
            return Ok(());
        }

        let request_str = std::str::from_utf8(&buf).unwrap();
        let mut request_path = String::new();
        for line in request_str.lines() {
            // println!("[info] request line '{}'", line);
            let parts: Vec<String> = line.split(" ").map(String::from).collect();
            if parts.len() != 3 || parts[0] != "GET" {
                continue;
            }
            request_path = parts[1].to_owned();
            break;
        }
        if request_path == "" {
            return Ok(());
        }
        if request_path == "/api/v1/files" {
            // API
            // println!("[info] api called");
            let mime_type = get_mime_type("api.json");
            let files = list_files_in_dir(directory).unwrap();
            let mut file_contents = String::from("[");
            for (i, f) in files.iter().enumerate() {
                file_contents.push('"');
                file_contents.push_str(f);
                file_contents.push('"');
                if i != files.len() - 1 {
                    file_contents.push_str(", ");
                }
            }
            file_contents.push(']');
            let response_headers = format!(
                "HTTP/1.1 200 OK\r\nContent-Type: {}; charset=UTF-8\r\nContent-Length: {}\r\n\r\n",
                mime_type,
                file_contents.len()
            );
            socket.write_all(response_headers.as_bytes()).await?;
            socket.write_all(file_contents.as_bytes()).await?;
            return Ok(());
        }
        if request_path == "/" {
            request_path = String::from("/index.html");
        }
        request_path = String::from(directory) + &request_path;
        // println!("[info] request for file at path '{}'", request_path);
        let file_contents = match read_file_into_memory(&request_path) {
            Some(x) => x,
            None => {
                println!("[error] failed to read the file, sending a 404");
                let response = "HTTP/1.1 404 Not Found\r\n\r\n".as_bytes();
                socket.write_all(response).await?;
                return Ok(());
            }
        };
        // println!("[info] sending the file in the response");
        let mime_type = get_mime_type(&request_path);
        let response_headers = format!(
            "HTTP/1.1 200 OK\r\nContent-Type: {}; charset=UTF-8\r\nContent-Length: {}\r\n\r\n",
            mime_type,
            file_contents.len()
        );
        socket.write_all(response_headers.as_bytes()).await?;
        socket.write_all(&file_contents).await?;
        return Ok(());
    }
}

fn get_mime_type(file_path: &str) -> String {
    if file_path == "" {
        return String::from("text/plain");
    }
    let parts: Vec<&str> = file_path.split(".").collect();
    if parts.len() < 2 {
        return String::from("application/octet-stream");
    }
    let ext = parts[parts.len() - 1];
    let result = match ext {
        "html" => "text/html",
        "js" => "text/javascript",
        "json" => "application/json",
        "css" => "text/css",
        "gif" => "image/gif",
        "ico" => "image/x-icon",
        "png" => "image/png",
        "jpeg" => "image/jpeg",
        "jpg" => "image/jpg",
        "mp4" => "video/mp4",
        "mkv" => "video/x-matroska",
        "md" => "text/plain",
        "txt" => "text/plain",
        _ => "application/octet-stream",
    };
    String::from(result)
}
