use std::env;
use std::fs;
use std::ops;

#[derive(Debug, Copy, Clone)]
struct Comp(f32, f32);

impl Comp {
    fn sq(self) -> Self {
        Comp(self.0 * self.0 - self.1 * self.1, 2. * self.0 * self.1)
    }
    fn len_sq(self) -> f32 {
        self.0 * self.0 + self.1 * self.1
    }
}

impl ops::Add for Comp {
    type Output = Comp;
    fn add(self, rhs: Self) -> Self::Output {
        Comp(self.0 + rhs.0, self.1 + rhs.1)
    }
}

impl std::fmt::Display for Comp {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "({}, {})", self.0, self.1)
    }
}

fn mandelbrot(rows: usize, cols: usize, iterations: usize) -> Vec<bool> {
    // println!("mandelbrot called");
    let totsize: usize = rows as usize * cols as usize;
    // println!("totsize {totsize}");
    let mut pixels: Vec<bool> = vec![true; totsize];
    // println!("pixels created");
    for row in 0..rows {
        // println!("row {row}");
        for col in 0..cols {
            let idx = row as usize * cols as usize + col as usize;
            let mut z = Comp(0., 0.);
            let x = col as f32 / cols as f32;
            let y = row as f32 / rows as f32;
            let c = Comp(x * 2. - 1.5, y * 2. - 1.);
            for _ in 0..iterations {
                z = z.sq() + c;
                if z.len_sq() >= 4. {
                    pixels[idx] = false;
                    break;
                }
            }
        }
    }
    pixels
}

fn draw_to_bitmap(rows: usize, cols: usize, pixels: &Vec<bool>) -> Vec<u8> {
    let mut result = vec![0; (rows * cols) as usize];
    let mut i = 7;
    let mut val: u8 = 0;
    for idx in 0..(rows * cols) {
        if pixels[idx as usize] {
            val |= 1 << i;
        }
        i -= 1;
        if i < 0 {
            result[idx as usize / 8] = val;
            val = 0;
            i = 7;
        }
    }
    let header_str = format!("P4\n{cols} {rows}\n");
    let header = Vec::from(header_str.as_bytes());
    [header, result].concat()
}

fn main() {
    let rows: usize = match env::var("NUM_ROWS") {
        Ok(x) => x.parse().unwrap(),
        Err(_) => 256,
    };
    let cols: usize = match env::var("NUM_COLS") {
        Ok(x) => x.parse().unwrap(),
        Err(_) => 256,
    };
    let iterations: usize = match env::var("NUM_ITERS") {
        Ok(x) => x.parse().unwrap(),
        Err(_) => 100,
    };
    let output_path = env::var("MY_OUTPUT_FILE").unwrap_or(String::from("mandelbrot.pbm"));
    let pixels = mandelbrot(rows, cols, iterations);
    let result = draw_to_bitmap(rows, cols, &pixels);
    fs::write(output_path, result).unwrap();
}
