use std::env;
use std::fs;
use std::time::Instant;

type Board = [[u8; 9]; 9];

fn partial_verify(board: &Board, x: u8, y: u8) -> bool {
    let base_x = (x / 3) * 3;
    let base_y = (y / 3) * 3;
    for i in 0..9 {
        if (i != y) && (board[x as usize][i as usize] == board[x as usize][y as usize]) {
            return false;
        }
        if (i != x) && (board[i as usize][y as usize] == board[x as usize][y as usize]) {
            return false;
        }
        let pos_x = base_x + (i / 3);
        let pos_y = base_y + (i % 3);
        if (pos_x != x || pos_y != y)
            && (board[pos_x as usize][pos_y as usize] == board[x as usize][y as usize])
        {
            return false;
        }
    }
    return true;
}

fn solve(board: &mut Board, x: u8, y: u8) -> bool {
    let z = (x * 9) + y + 1;
    if z == 82 {
        return true;
    }
    if board[x as usize][y as usize] != 0 {
        return solve(board, z / 9, z % 9);
    }
    for i in 1..=9 {
        board[x as usize][y as usize] = i;
        if partial_verify(board, x, y) {
            if solve(board, z / 9, z % 9) {
                return true;
            }
        }
    }
    board[x as usize][y as usize] = 0;
    return false;
}

fn verify(board: &Board) -> bool {
    for i in 0..9 {
        let mut row_check = [false; 10];
        let mut col_check = [false; 10];
        for j in 0..9 {
            if board[i][j] == 0 {
                return false;
            }
            if row_check[board[i][j] as usize] {
                return false;
            }
            row_check[board[i][j] as usize] = true;
            if col_check[board[i][j] as usize] {
                return false;
            }
            col_check[board[i][j] as usize] = true;
        }
    }
    for i in (0..9).step_by(3) {
        for j in (0..9).step_by(3) {
            let mut check = [false; 10];
            for k in 0..9 {
                let x = i + (k / 3);
                let y = j + (k % 3);
                if check[board[x][y] as usize] {
                    return false;
                }
                check[board[x][y] as usize] = true;
            }
        }
    }
    return true;
}

fn read_line(line: &str) -> Board {
    let mut board = Board::default();
    let ascii_zero: u8 = b'0';
    let ascii_dot: u8 = b'.';
    let cs = line.as_bytes();
    for i in 0..9 {
        for j in 0..9 {
            let mut ch = cs[(i * 9 + j) as usize];
            if ch == ascii_dot {
                ch = ascii_zero;
            }
            board[i][j] = ch - ascii_zero;
        }
    }
    board
}
fn main() {
    let args = env::args().collect::<Vec<String>>();
    if args.len() != 2 {
        println!("usage: sudoku <path/to/sudoku/board/file>");
        std::process::exit(1);
    }
    // println!("got the args {:?}", args);
    let input_path = &args[1];
    // println!("reading the file at path '{}'", input_path);
    // let start_instant = Instant::now();
    // let t0 = start_instant.elapsed().as_nanos();
    let read_result = fs::read_to_string(input_path);
    let input_txt = match read_result {
        Ok(x) => x,
        Err(e) => {
            println!(
                "failed to read the file at path '{}' . error: {}",
                input_path, e
            );
            std::process::exit(1);
        }
    };
    // let t1 = start_instant.elapsed().as_nanos();
    // println!("contents of the file:\n{}", input_txt);
    // println!("[info] read file: {} ns", t1 - t0);
    for line in input_txt.lines() {
        // for (i, line) in input_txt.lines().enumerate() {
        // println!("solving line {}: {}", i, line);
        if line.len() != 9 * 9 {
            println!("line is invalid. length: {}", line.len());
            continue;
        }
        let mut board = read_line(line);
        // println!("got the board: {:?}", board);
        solve(&mut board, 0, 0);
        // println!("solved board: {:?}", board);
        assert!(verify(&board));
    }
    // let t2 = start_instant.elapsed().as_nanos();
    // println!("[info] sudoku: {} ns", t2 - t1);
}
