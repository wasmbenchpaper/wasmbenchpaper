import numpy as np

# NUM_ROWS=64
# NUM_COLS=128
# NUM_ITERS=100

def get_mandelbrot_simd(num_rows=64, num_cols=128, num_iters=100):
    rs = np.arange(num_rows)
    cs = np.arange(num_cols)

    # print(rs, rs.shape)
    # print(cs, cs.shape)

    cx = 2 * cs / num_cols - 1.5
    cy = 2 * rs / num_rows - 1

    # print(cx, cx.shape)
    # print(cy, cy.shape)

    zx = np.zeros((num_rows, num_cols))
    zy = np.zeros((num_rows, num_cols))

    # print(zx, zx.shape)
    # print(zy, zy.shape)

    for _ in range(num_iters):
        nzx = zx * zx - zy * zy + cx.reshape(1, num_cols)
        nzy = 2 * zx * zy + cy.reshape(num_rows, 1)
        # print(nzx, nzx.shape)
        # print(nzy, nzy.shape)
        zx = nzx 
        zy = nzy

    # print('after loop')
    # print('-'*64)
    # print(zx, zx.shape)
    # print(zy, zy.shape)

    mag = zx*zx+zy*zy
    # print(mag, mag.shape)

    mag = np.where(mag <= 4, 1, 0)
    # print('final result')
    # print(mag, mag.shape)
    rows = []
    for qs in mag:
        row = []
        for q in qs:
            row.append('*' if q else '.')
        rows.append(''.join(row))
    return '\n'.join(rows)

def main():
    mandelbrot = get_mandelbrot_simd(num_rows=NUM_ROWS, num_cols=NUM_COLS, num_iters=NUM_ITERS)
    # print(mandelbrot)


main()
