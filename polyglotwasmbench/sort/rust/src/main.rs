use std::time::Instant;

type AsciiString = Vec<char>;

fn wmerge(arr: &mut [AsciiString], _lo1: usize, hi1: usize, _lo2: usize, hi2: usize, _w: usize) {
    let mut lo1 = _lo1;
    let mut lo2 = _lo2;
    let mut w = _w;
    while (lo1 < hi1) && (lo2 < hi2) {
        let lo_old;
        if arr[lo1] <= arr[lo2] {
            lo_old = lo1;
            lo1 += 1;
        } else {
            lo_old = lo2;
            lo2 += 1;
        }
        let w_old = w;
        w += 1;
        arr.swap(w_old, lo_old);
    }
    while lo1 < hi1 {
        let w_old = w;
        w += 1;
        let lo_old = lo1;
        lo1 += 1;
        arr.swap(w_old, lo_old);
    }
    while lo2 < hi2 {
        let w_old = w;
        w += 1;
        let lo_old = lo2;
        lo2 += 1;
        arr.swap(w_old, lo_old);
    }
}

fn wsort(arr: &mut [AsciiString], lo: usize, hi: usize, w: usize) {
    if (hi - lo) > 1 {
        let m = (lo + hi) / 2;
        imsort(arr, lo, m);
        imsort(arr, m, hi);
        wmerge(arr, lo, m, m, hi, w);
    } else if lo != hi {
        arr.swap(lo, w);
    }
}

fn imsort(arr: &mut [AsciiString], lo: usize, hi: usize) {
    if (hi - lo) > 1 {
        let m = (lo + hi) / 2;
        let mut w = lo + hi - m;
        wsort(arr, lo, m, w);
        while (w - lo) > 2 {
            let n = w;
            w = (lo + n + 1) / 2;
            wsort(arr, w, n, lo);
            wmerge(arr, lo, lo + n - w, n, hi, w);
        }
        for i in ((lo + 1)..(w + 1)).rev() {
            let mut j = i;
            while (j < hi) && (arr[j] < arr[j - 1]) {
                arr.swap(j, j - 1);
                j += 1;
            }
        }
    }
}

fn permute(l: &mut [AsciiString], n: usize, m: usize, pos: usize) {
    if n == 0 {
        return;
    }
    let size = m.pow((n - 1) as u32);
    for i in 0..m {
        for j in 0..size {
            l[i * size + j][pos] = (('z' as u8) - (i as u8)) as char;
        }
        let idx = i * size;
        permute(&mut l[idx..], n - 1, m, pos + 1);
    }
}

fn get_box_str(n: usize) -> Vec<char> {
    (0..n).map(|_| 0 as char).collect()
}

fn gen_array(n: usize, m: usize) -> (usize, Vec<AsciiString>) {
    // let start_instant = Instant::now();
    let size = m.pow(n as u32);
    let mut l: Vec<AsciiString> = (0..size).map(|_| get_box_str(n)).collect();
    permute(&mut l, n, m, 0);
    // let t0 = start_instant.elapsed().as_nanos();
    // println!("[info] permute: {} ns", t0);
    return (size, l);
}

fn verify_array(l: &[AsciiString]) -> bool {
    let s = l.len();
    for i in 1..s {
        if l[i - 1] > l[i] {
            return false;
        }
    }
    return true;
}

fn main() {
    // let start_instant = Instant::now();
    // let t0 = start_instant.elapsed().as_nanos();
    let (size, mut l) = gen_array(4, 18);
    // let t1 = start_instant.elapsed().as_nanos();
    imsort(&mut l, 0, size);
    // let t2 = start_instant.elapsed().as_nanos();
    // println!("[info] gen_array: {} ns", t1 - t0);
    // println!("[info] sort: {} ns", t2 - t1);
    assert!(verify_array(&l));
}
