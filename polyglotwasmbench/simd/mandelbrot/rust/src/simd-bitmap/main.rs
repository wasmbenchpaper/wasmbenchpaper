#![feature(portable_simd)]

use std::env;
use std::fs;
use std::simd::Simd;

#[target_feature(enable = "simd128")]
fn mandelbrot(rows: usize, cols: usize, iterations: usize) -> Vec<bool> {
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
