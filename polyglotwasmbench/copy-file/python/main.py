#!/usr/bin/env python
import os
import sys
from shutil import copyfile
# from time import perf_counter
# from time import perf_counter_ns

def main():
    args = sys.argv
    # print('running with args:', args)
    if len(args) != 3:
        print('usage: copy path/to/src path/to/dest')
        sys.exit(1)
    input_path = args[1]
    output_path = args[2]
    # print('copying')
    if os.path.isdir(output_path):
        src_filename = os.path.basename(input_path)
        output_path = os.path.join(output_path, src_filename)
    # t0 = perf_counter_ns()
    # t0 = perf_counter()
    copyfile(input_path, output_path)
    # t1 = perf_counter_ns()
    # t1 = perf_counter()
    # with open(input_path, 'r') as f:
    #     contents = f.read()
    #     print('contents of source file is:', contents)
    # with open(output_path, 'w') as f:
    #     f.write(contents)
    # print(f't0 {t0} t1 {t1}')
    # print(f'[info] copy done in: {t1 - t0} ns')
    # print(f'[info] copy done in: {t1 - t0} s')
    # print('done')

main()
