#![feature(portable_simd)]

use std::simd::Simd;

#[target_feature(enable = "simd128")]
fn mandelbrot(rows: u8, cols: u8, iterations: u8) -> Vec<bool> {
    const BATCH_SIZE: usize = 4; // 128 bit as 4 x 32 bit floats
                                 // println!("mandelbrot called");
    let totsize: usize = rows as usize * cols as usize;
    // println!("totsize {totsize}");
    let mut pixels: Vec<bool> = vec![true; totsize];
    // println!("pixels created");
    for row in 0..rows {
        // println!("row {row}");
        let batch_rows = Simd::splat(row as f32);
        let batch_ys: Simd<f32, BATCH_SIZE> = batch_rows * Simd::splat(1. / rows as f32);
        let batch_ys_norm: Simd<f32, BATCH_SIZE> = batch_ys * Simd::splat(2.) - Simd::splat(1.);
        for col in (0..cols).step_by(BATCH_SIZE) {
            // let batch_xs : [f32; BATCH_SIZE] = [0.; BATCH_SIZE];
            let batch_cols = Simd::from([
                col as f32,
                (col + 1) as f32,
                (col + 2) as f32,
                (col + 3) as f32,
            ]);
            let batch_idxs = batch_rows * Simd::splat(cols as f32) + batch_cols;
            let batch_xs: Simd<f32, BATCH_SIZE> = batch_cols * Simd::splat(1. / cols as f32);
            let batch_xs_norm: Simd<f32, BATCH_SIZE> =
                batch_xs * Simd::splat(2.) - Simd::splat(1.5);
            // let idx = row as usize * cols as usize + col as usize;
            // let mut z = Comp(0., 0.);
            let mut batch_z_xs: Simd<f32, BATCH_SIZE> = Simd::splat(0.);
            let mut batch_z_ys: Simd<f32, BATCH_SIZE> = Simd::splat(0.);
            // let x = col as f32 / cols as f32;
            // let y = row as f32 / rows as f32;
            // let c = Comp(x * 2. - 1.5, y * 2. - 1.);
            for _ in 0..iterations {
                let batch_z_new_xs =
                    batch_z_xs * batch_z_xs - batch_z_ys * batch_z_ys + batch_xs_norm;
                let batch_z_new_ys = Simd::splat(2.) * batch_z_xs * batch_z_ys + batch_ys_norm;
                batch_z_xs = batch_z_new_xs;
                batch_z_ys = batch_z_new_ys;
                // z = z.sq() + c;
                // if z.len_sq() >= 4. {
                //     pixels[idx] = false;
                //     break;
                // }
            }
            let batch_z_len_sq = batch_z_xs * batch_z_xs + batch_z_ys * batch_z_ys;
            let batch_z_len_sq_arr = batch_z_len_sq.as_array();
            let batch_idxs_arr = batch_idxs.as_array();
            pixels[batch_idxs_arr[0] as usize] = batch_z_len_sq_arr[0] <= 4.;
            pixels[batch_idxs_arr[1] as usize] = batch_z_len_sq_arr[1] <= 4.;
            pixels[batch_idxs_arr[2] as usize] = batch_z_len_sq_arr[2] <= 4.;
            pixels[batch_idxs_arr[3] as usize] = batch_z_len_sq_arr[3] <= 4.;
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
