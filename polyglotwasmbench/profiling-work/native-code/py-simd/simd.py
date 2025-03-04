import sys
import numpy as np

# NUM_ROWS=64
# NUM_COLS=128
# NUM_ITERS=100

def to_bitmap(rows):
    height = len(rows)
    width = len(rows[0])
    bs = bytearray((width * height) // 8)
    idx = 0
    i = 7
    x = 0
    for row in rows:
        for cell in row:
            x |= cell << i
            i -= 1
            if i < 0:
                bs[idx] = x
                i = 7
                x = 0
                idx += 1
    return bytes(f"P4\n{width} {height}\n", encoding="ascii") + bs


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
    return mag
    # rows = []
    # for qs in mag:
    #     row = []
    #     for q in qs:
    #         row.append('*' if q else '.')
    #     rows.append(''.join(row))
    # return '\n'.join(rows)

def main():
    args = sys.argv
    # print('running with args', args)
    if len(args) != 4:
        print("usage: mandelbrot <width> <height> <iterations>")
        return
    try:
        width = int(args[1])
        height = int(args[2])
        num_iters = int(args[3])
        width = 8 * (width // 8)
        height = 8 * (height // 8)
    except:
        print("invalid args")
        return
    # print('width', width, 'height', height, 'num_iters', num_iters)
    mandelbrot = get_mandelbrot_simd(num_rows=height, num_cols=width, num_iters=num_iters)
    print(mandelbrot)
    print(to_bitmap(mandelbrot))
    sys.stdout.buffer.write(to_bitmap(mandelbrot))
    return to_bitmap(mandelbrot)


main()
