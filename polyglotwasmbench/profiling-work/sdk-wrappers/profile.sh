#!/usr/bin/env bash

#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

set -e


echo 'BENCHMARK WASMS ON BAREMETAL'

if [ -z "$iter" ]; then
  echo "iter is empty or not set."
  exit 1
fi


lang=rust
wl=sort
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl
cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./wrapper ./main.wasm > "$LOGS_DIR/perfrecord.log"
syscount -c ./wrapper ./main.wasm > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./wrapper ./main.wasm > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./wrapper ./main.wasm > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./wrapper ./main.wasm > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./wrapper ./main.wasm 2> $LOGS_DIR/ptrace.txt
{ time ./wrapper ./main.wasm; } 2> $LOGS_DIR/time.txt

cd - || exit 1

lang=rust
wl=copyfile
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl
cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./wrapper ./main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfrecord.log"
syscount -c ./wrapper ./main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./wrapper ./main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./wrapper ./main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./wrapper ./main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./wrapper ./main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 2> $LOGS_DIR/ptrace.txt
{ time ./wrapper ./main.wasm ./move2kube.mp4 ./move2kube_copy.mp4; } 2> $LOGS_DIR/time.txt

cd - || exit 1

lang=rust
wl=sudoku
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl
cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./wrapper ./main.wasm ./input-64.txt > "$LOGS_DIR/perfrecord.log"
syscount -c ./wrapper ./main.wasm ./input-64.txt > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./wrapper ./main.wasm ./input-64.txt > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./wrapper ./main.wasm ./input-64.txt > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./wrapper ./main.wasm ./input-64.txt > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./wrapper ./main.wasm ./input-64.txt 2> $LOGS_DIR/ptrace.txt
{ time ./wrapper ./main.wasm ./input-64.txt; } 2> $LOGS_DIR/time.txt

cd - || exit 1

lang=rust
wl=graph
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl
cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./wrapper ./main.wasm graph-250000-edges.txt > "$LOGS_DIR/perfrecord.log"
syscount -c ./wrapper ./main.wasm graph-250000-edges.txt > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./wrapper ./main.wasm graph-250000-edges.txt > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./wrapper ./main.wasm graph-250000-edges.txt > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./wrapper ./main.wasm graph-250000-edges.txt > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./wrapper ./main.wasm graph-250000-edges.txt 2> $LOGS_DIR/ptrace.txt
{ time ./wrapper ./main.wasm graph-250000-edges.txt; } 2> $LOGS_DIR/time.txt


cd - || exit 1


lang=rust
wl=simd
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl
cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./wrapper ./simd.wasm 256 256 100 > "$LOGS_DIR/perfrecord.log"
syscount -c ./wrapper ./simd.wasm 256 256 100 > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./wrapper ./simd.wasm 256 256 100 > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./wrapper ./simd.wasm 256 256 100 > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./wrapper ./simd.wasm 256 256 100 > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./wrapper ./simd.wasm 256 256 100 2> $LOGS_DIR/ptrace.txt
{ time ./wrapper ./simd.wasm 256 256 100; } 2> $LOGS_DIR/time.txt


lang=rust
wl=nosimd
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
wl=simd
workload=$lang-$wl
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./wrapper ./nosimd.wasm 256 256 100 > "$LOGS_DIR/perfrecord.log"
syscount -c ./wrapper ./nosimd.wasm 256 256 100 > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./wrapper ./nosimd.wasm 256 256 100 > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./wrapper ./nosimd.wasm 256 256 100 > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./wrapper ./nosimd.wasm 256 256 100 > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./wrapper ./nosimd.wasm 256 256 100 2> $LOGS_DIR/ptrace.txt
{ time ./wrapper ./nosimd.wasm 256 256 100; } 2> $LOGS_DIR/time.txt

cd - || exit 1


lang=c
wl=sort
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl
cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./wrapper ./main.wasm > "$LOGS_DIR/perfrecord.log"
syscount -c ./wrapper ./main.wasm > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./wrapper ./main.wasm > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./wrapper ./main.wasm > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./wrapper ./main.wasm > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./wrapper ./main.wasm 2> $LOGS_DIR/ptrace.txt
{ time ./wrapper ./main.wasm; } 2> $LOGS_DIR/time.txt

cd - || exit 1

lang=c
wl=copyfile
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl
cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./wrapper ./main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfrecord.log"
syscount -c ./wrapper ./main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./wrapper ./main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./wrapper ./main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./wrapper ./main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./wrapper ./main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 2> $LOGS_DIR/ptrace.txt
{ time ./wrapper ./main.wasm ./move2kube.mp4 ./move2kube_copy.mp4; } 2> $LOGS_DIR/time.txt

cd - || exit 1

lang=c
wl=sudoku
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl
cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./wrapper ./main.wasm ./input-64.txt > "$LOGS_DIR/perfrecord.log"
syscount -c ./wrapper ./main.wasm ./input-64.txt > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./wrapper ./main.wasm ./input-64.txt > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./wrapper ./main.wasm ./input-64.txt > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./wrapper ./main.wasm ./input-64.txt > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./wrapper ./main.wasm ./input-64.txt 2> $LOGS_DIR/ptrace.txt
{ time ./wrapper ./main.wasm ./input-64.txt; } 2> $LOGS_DIR/time.txt

cd - || exit 1

lang=c
wl=graph
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl
cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./wrapper ./main.wasm graph-250000-edges.txt > "$LOGS_DIR/perfrecord.log"
syscount -c ./wrapper ./main.wasm graph-250000-edges.txt > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./wrapper ./main.wasm graph-250000-edges.txt > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./wrapper ./main.wasm graph-250000-edges.txt > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./wrapper ./main.wasm graph-250000-edges.txt > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./wrapper ./main.wasm graph-250000-edges.txt 2> $LOGS_DIR/ptrace.txt
{ time ./wrapper ./main.wasm graph-250000-edges.txt; } 2> $LOGS_DIR/time.txt

cd - || exit 1

lang=c
wl=simd
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl
cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./wrapper ./simd.wasm 256 256 100 > "$LOGS_DIR/perfrecord.log"
syscount -c ./wrapper ./simd.wasm 256 256 100 > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./wrapper ./simd.wasm 256 256 100 > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./wrapper ./simd.wasm 256 256 100 > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./wrapper ./simd.wasm 256 256 100 > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./wrapper ./simd.wasm 256 256 100 2> $LOGS_DIR/ptrace.txt
{ time ./wrapper ./simd.wasm 256 256 100; } 2> $LOGS_DIR/time.txt

lang=c
wl=nosimd
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
wl=simd
workload=$lang-$wl
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./wrapper ./nosimd.wasm 256 256 100 > "$LOGS_DIR/perfrecord.log"
syscount -c ./wrapper ./nosimd.wasm 256 256 100 > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./wrapper ./nosimd.wasm 256 256 100 > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./wrapper ./nosimd.wasm 256 256 100 > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./wrapper ./nosimd.wasm 256 256 100 > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./wrapper ./nosimd.wasm 256 256 100 2> $LOGS_DIR/ptrace.txt
{ time ./wrapper ./nosimd.wasm 256 256 100; } 2> $LOGS_DIR/time.txt

cd - || exit 1

lang=go
wl=sort
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl
cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./wrapper ./main.wasm > "$LOGS_DIR/perfrecord.log"
syscount -c ./wrapper ./main.wasm > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./wrapper ./main.wasm > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./wrapper ./main.wasm > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./wrapper ./main.wasm > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./wrapper ./main.wasm 2> $LOGS_DIR/ptrace.txt
{ time ./wrapper ./main.wasm; } 2> $LOGS_DIR/time.txt

cd - || exit 1

lang=go
wl=copyfile
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl
cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./wrapper ./main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfrecord.log"
syscount -c ./wrapper ./main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./wrapper ./main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./wrapper ./main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./wrapper ./main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./wrapper ./main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 2> $LOGS_DIR/ptrace.txt
{ time ./wrapper ./main.wasm ./move2kube.mp4 ./move2kube_copy.mp4; } 2> $LOGS_DIR/time.txt

cd - || exit 1

lang=go
wl=sudoku
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl
cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./wrapper ./main.wasm ./input-64.txt > "$LOGS_DIR/perfrecord.log"
syscount -c ./wrapper ./main.wasm ./input-64.txt > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./wrapper ./main.wasm ./input-64.txt > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./wrapper ./main.wasm ./input-64.txt > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./wrapper ./main.wasm ./input-64.txt > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./wrapper ./main.wasm ./input-64.txt 2> $LOGS_DIR/ptrace.txt
{ time ./wrapper ./main.wasm ./input-64.txt; } 2> $LOGS_DIR/time.txt

cd - || exit 1

lang=go
wl=graph
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl
cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./wrapper ./main.wasm graph-250000-edges.txt > "$LOGS_DIR/perfrecord.log"
syscount -c ./wrapper ./main.wasm graph-250000-edges.txt > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./wrapper ./main.wasm graph-250000-edges.txt > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./wrapper ./main.wasm graph-250000-edges.txt > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./wrapper ./main.wasm graph-250000-edges.txt > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./wrapper ./main.wasm graph-250000-edges.txt 2> $LOGS_DIR/ptrace.txt
{ time ./wrapper ./main.wasm graph-250000-edges.txt; } 2> $LOGS_DIR/time.txt

cd - || exit 1

lang=go
wl=simd
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl
cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./wrapper ./simd.wasm 256 256 100 > "$LOGS_DIR/perfrecord.log"
syscount -c ./wrapper ./simd.wasm 256 256 100 > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./wrapper ./simd.wasm 256 256 100 > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./wrapper ./simd.wasm 256 256 100 > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./wrapper ./simd.wasm 256 256 100 > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./wrapper ./simd.wasm 256 256 100 2> $LOGS_DIR/ptrace.txt
{ time ./wrapper ./simd.wasm 256 256 100; } 2> $LOGS_DIR/time.txt

cd - || exit 1

lang=go
wl=nosimd
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
wl=simd
workload=$lang-$wl
cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./wrapper ./nosimd.wasm 256 256 100 > "$LOGS_DIR/perfrecord.log"
syscount -c ./wrapper ./nosimd.wasm 256 256 100 > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./wrapper ./nosimd.wasm 256 256 100 > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./wrapper ./nosimd.wasm 256 256 100 > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./wrapper ./nosimd.wasm 256 256 100 > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./wrapper ./nosimd.wasm 256 256 100 2> $LOGS_DIR/ptrace.txt
{ time ./wrapper ./nosimd.wasm 256 256 100; } 2> $LOGS_DIR/time.txt

cd - || exit 1


lang=py
wl=sort
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl
cd ./$workload || exit 1
pip install numpy
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" python3 wrapper.py main.wasm > "$LOGS_DIR/perfrecord.log"
syscount -c python3 wrapper.py main.wasm > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" python3 wrapper.py main.wasm > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord python3 wrapper.py main.wasm > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" python3 wrapper.py main.wasm > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s python3 wrapper.py main.wasm 2> $LOGS_DIR/ptrace.txt
{ time python3 wrapper.py main.wasm; } 2> $LOGS_DIR/time.txt

cd - || exit 1

lang=py
wl=copyfile
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl
cd ./$workload || exit 1
pip install numpy
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" python3 wrapper.py main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfrecord.log"
syscount -c python3 wrapper.py main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" python3 wrapper.py main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord python3 wrapper.py main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" python3 wrapper.py main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s python3 wrapper.py main.wasm ./move2kube.mp4 ./move2kube_copy.mp4 2> $LOGS_DIR/ptrace.txt
{ time python3 wrapper.py main.wasm ./move2kube.mp4 ./move2kube_copy.mp4; } 2> $LOGS_DIR/time.txt

cd - || exit 1

lang=py
wl=sudoku
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl
cd ./$workload || exit 1
pip install numpy
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" python3 wrapper.py main.wasm ./input-64.txt > "$LOGS_DIR/perfrecord.log"
syscount -c python3 wrapper.py main.wasm ./input-64.txt > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" python3 wrapper.py main.wasm ./input-64.txt > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord python3 wrapper.py main.wasm ./input-64.txt > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" python3 wrapper.py main.wasm ./input-64.txt > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s python3 wrapper.py main.wasm ./input-64.txt 2> $LOGS_DIR/ptrace.txt
{ time python3 wrapper.py main.wasm ./input-64.txt; } 2> $LOGS_DIR/time.txt

cd - || exit 1

lang=py
wl=graph
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl
cd ./$workload || exit 1
pip install numpy
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" python3 wrapper.py main.wasm ./graph-250000-edges.txt > "$LOGS_DIR/perfrecord.log"
syscount -c python3 wrapper.py main.wasm ./graph-250000-edges.txt > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" python3 wrapper.py main.wasm ./graph-250000-edges.txt > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord python3 wrapper.py main.wasm ./graph-250000-edges.txt > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" python3 wrapper.py main.wasm ./graph-250000-edges.txt > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s python3 wrapper.py main.wasm ./graph-250000-edges.txt 2> $LOGS_DIR/ptrace.txt
{ time python3 wrapper.py main.wasm ./graph-250000-edges.txt; } 2> $LOGS_DIR/time.txt

cd - || exit 1

lang=py
wl=simd
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl
cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" python3 wrapper.py simd.wasm > "$LOGS_DIR/perfrecord.log"
syscount -c python3 wrapper.py simd.wasm > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" python3 wrapper.py simd.wasm > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord python3 wrapper.py simd.wasm > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" python3 wrapper.py simd.wasm > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s python3 wrapper.py simd.wasm 2> $LOGS_DIR/ptrace.txt
{ time python3 wrapper.py simd.wasm; } 2> $LOGS_DIR/time.txt


lang=py
wl=nosimd
OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
wl=simd
workload=$lang-$wl
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" python3 wrapper.py nosimd.wasm > "$LOGS_DIR/perfrecord.log"
syscount -c python3 wrapper.py nosimd.wasm > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" python3 wrapper.py nosimd.wasm > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord python3 wrapper.py nosimd.wasm > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" python3 wrapper.py nosimd.wasm > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s python3 wrapper.py nosimd.wasm 2> $LOGS_DIR/ptrace.txt
{ time python3 wrapper.py nosimd.wasm; } 2> $LOGS_DIR/time.txt

cd - || exit 1

echo 'done'
