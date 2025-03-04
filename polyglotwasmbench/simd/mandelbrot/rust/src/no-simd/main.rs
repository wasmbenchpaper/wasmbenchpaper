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

fn mandelbrot(rows: u8, cols: u8, iterations: u8) -> Vec<bool> {
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

fn draw_to_string(rows: u8, cols: u8, pixels: &Vec<bool>) -> String {
    let mut result = String::new();
    for row in 0..rows {
        let mut row_str = String::new();
        for col in 0..cols {
            let idx = row as usize * cols as usize + col as usize;
            row_str += if pixels[idx] { "*" } else { "." }
        }
        result += &row_str;
        result += "\n";
    }
    result
}

fn main() {
    const ROWS: u8 = 64;
    const COLS: u8 = ROWS * 2;
    const ITERATIONS: u8 = 100;
    let pixels = mandelbrot(ROWS, COLS, ITERATIONS);
    let result = draw_to_string(ROWS, COLS, &pixels);
    print!("{result}");
}
