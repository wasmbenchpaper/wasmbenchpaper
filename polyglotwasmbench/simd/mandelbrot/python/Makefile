install:
	corepack enable && pnpm install

run:
	pnpm start

run-custom-wheel:
	pnpm run start-custom-wheel

run-bitmap:
	pnpm run start-bitmap

run-python-bitmap:
	python3 main-bitmap.py > mandelbrot.pbm

run-extra-large:
	WITH_SIMD=true NUM_ROWS=5000 NUM_COLS=5000 NUM_ITERS=200 node index-bitmap.js
