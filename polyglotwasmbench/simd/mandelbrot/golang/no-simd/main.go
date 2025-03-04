package main

import "fmt"

func mandelbrot(rows int, cols int, iterations int) []bool {
	pixels := make([]bool, rows*cols)
	for row := 0; row < rows; row++ {
		cy := 2.*(float32(row)/float32(rows)) - 1.
		for col := 0; col < cols; col++ {
			cx := 2.*(float32(col)/float32(cols)) - 1.5
			c := complex(cx, cy)
			var z complex64 = complex(0, 0)
			for i := 0; i < iterations; i++ {
				z = z*z + c
				len_sq := real(z)*real(z) + imag(z)*imag(z)
				if len_sq > 4 {
					pixels[row*cols+col] = true // not in mandelbrot set
					break
				}
			}
		}
	}
	return pixels
}

func draw_to_string(rows int, cols int, pixels []bool) string {
	result := ""
	for row := 0; row < rows; row++ {
		rowStr := ""
		for col := 0; col < cols; col++ {
			if pixels[row*cols+col] {
				// not in mandelbrot set
				rowStr += "."
			} else {
				rowStr += "*"
			}
		}
		result += rowStr + "\n"
	}
	return result
}

func main() {
	const (
		ROWS       int = 64
		COLS       int = ROWS * 2
		ITERATIONS int = 100
	)
	pixels := mandelbrot(ROWS, COLS, ITERATIONS)
	result := draw_to_string(ROWS, COLS, pixels)
	fmt.Print(result)
}
