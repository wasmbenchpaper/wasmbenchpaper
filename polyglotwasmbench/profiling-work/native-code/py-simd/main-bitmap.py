import sys


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


def get_mandelbrot(num_rows=64, num_cols=128, num_iters=100):
    rows = []
    for r in range(num_rows):
        cy = 2 * r / num_rows - 1
        row = []
        for c in range(num_cols):
            cx = 2 * c / num_cols - 1.5
            zx = 0
            zy = 0
            yes = True
            for _ in range(num_iters):
                nzx = zx * zx - zy * zy + cx
                nzy = 2 * zx * zy + cy
                zx = nzx
                zy = nzy
                if zx * zx + zy * zy > 4:
                    yes = False
                    break
            row.append(1 if yes else 0)
        rows.append(row)
    return rows


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
    mandelbrot = get_mandelbrot(num_rows=height, num_cols=width, num_iters=num_iters)
    # print(mandelbrot)
    # print(to_bitmap(mandelbrot))
    sys.stdout.buffer.write(to_bitmap(mandelbrot))


main()
