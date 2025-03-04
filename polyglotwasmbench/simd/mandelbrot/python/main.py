# chars = [".", "-", "+", "x", "*", "@"]
# chars_len = len(chars)
# last_char = chars[chars_len - 1]

# NUM_ROWS=64
# NUM_COLS=128
# NUM_ITERS=100

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
            # char = last_char
            for _ in range(num_iters):
                # for i in range(num_iters):
                nzx = zx * zx - zy * zy + cx
                nzy = 2 * zx * zy + cy
                zx = nzx
                zy = nzy
                if zx * zx + zy * zy > 4:
                    yes = False
                    # char = chars[i%chars_len]
                    break
            row.append("*" if yes else ".")
            # row.append(char)
        rows.append("".join(row))
    return "\n".join(rows)


def main():
    mandelbrot = get_mandelbrot(num_rows=NUM_ROWS, num_cols=NUM_COLS, num_iters=NUM_ITERS)
    # print(mandelbrot)


main()
