use std::io::Write;

use tokio::io::{AsyncReadExt, AsyncWriteExt};
use tokio::net::{TcpListener, TcpStream};

#[tokio::main(flavor = "current_thread")]

async fn main() -> std::io::Result<()> {
    let args: Vec<String> = std::env::args().collect();
    let address = args[1].to_owned();
    let port: u16 = args[2].parse().expect("invalid port number");
    let listener = TcpListener::bind(format!("{address}:{port}")).await?;

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
        tokio::spawn(async move {
            eprintln!("> CONNECTED");
            match handle(socket).await {
                Ok(()) => eprintln!("> DISCONNECTED"),
                Err(e) => eprintln!("> ERROR: {}", e),
            }
        });
    }
}

async fn handle(mut socket: TcpStream) -> std::io::Result<()> {
    loop {
        let mut buf = [0u8; 4096];

        // Read some bytes from the socket.
        let read = socket.read(&mut buf).await?;

        // Handle a clean disconnection.
        if read == 0 {
            return Ok(());
        }

        // Write bytes both locally and remotely.
        std::io::stdout().write_all(&buf[..read])?;
        socket.write_all(&buf[..read]).await?;
    }
}
