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

echo 'BENCHMARK NATIVE CODE ON BAREMETAL'

if [ -z "$iter" ]; then
  echo "iter is empty or not set."
  exit 1
fi

lang=rust
wl=sort
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
mkdir -p "$OUTPUT_DIR"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./sort > "$LOGS_DIR/perfrecord.log"
syscount -c ./sort > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./sort > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./sort > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./sort > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./sort 2> "$LOGS_DIR/ptrace.txt"
{ time  ./sort; } 2> $LOGS_DIR/time.txt
cd - || exit 1


lang=rust
wl=copyfile
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./copy ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfrecord.log"
syscount -c ./copy ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./copy ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./copy ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./copy ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./copy ./move2kube.mp4 ./move2kube_copy.mp4 2> "$LOGS_DIR/ptrace.txt"
{ time ./copy ./move2kube.mp4 ./move2kube_copy.mp4; } 2> $LOGS_DIR/time.txt
cd - || exit 1

lang=rust
wl=sudoku
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./sudoku input-64.txt > "$LOGS_DIR/perfrecord.log"
syscount -c ./sudoku input-64.txt > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./sudoku input-64.txt > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./sudoku input-64.txt > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./sudoku input-64.txt > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./sudoku input-64.txt 2> "$LOGS_DIR/ptrace.txt"
{ time ./sudoku input-64.txt; } 2> $LOGS_DIR/time.txt
cd - || exit 1


lang=rust
wl=graph
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./graph graph-250000-edges.txt > "$LOGS_DIR/perfrecord.log"
syscount -c ./graph graph-250000-edges.txt > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./graph graph-250000-edges.txt > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./graph graph-250000-edges.txt > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./graph graph-250000-edges.txt > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./graph graph-250000-edges.txt 2> "$LOGS_DIR/ptrace.txt"
{ time ./graph graph-250000-edges.txt; } 2> $LOGS_DIR/time.txt
cd - || exit 1


lang=rust
wl=simd
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./simd 256 256 100 > "$LOGS_DIR/perfrecord.log"
syscount -c ./simd 256 256 100 > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./simd 256 256 100 > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./simd 256 256 100 > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./simd 256 256 100 > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./simd 256 256 100 2> "$LOGS_DIR/ptrace.txt"
{ time ./simd 256 256 100; } 2> $LOGS_DIR/time.txt

lang=rust
wl=nosimd
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./nosimd 256 256 100 > "$LOGS_DIR/perfrecord.log"
syscount -c ./nosimd 256 256 100 > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./nosimd 256 256 100 > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./nosimd 256 256 100 > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./nosimd 256 256 100 > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./nosimd 256 256 100 2> "$LOGS_DIR/ptrace.txt"
{ time ./nosimd 256 256 100; } 2> $LOGS_DIR/time.txt
cd - || exit 1


lang=c
wl=sort
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./sort > "$LOGS_DIR/perfrecord.log"
syscount -c ./sort > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./sort > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./sort > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./sort > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./sort 2> "$LOGS_DIR/ptrace.txt"
{ time ./sort; } 2> $LOGS_DIR/time.txt
cd - || exit 1


lang=c
wl=copyfile
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./copy ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfrecord.log"
syscount -c ./copy ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./copy ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./copy ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./copy ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./copy ./move2kube.mp4 ./move2kube_copy.mp4 2> "$LOGS_DIR/ptrace.txt"
{ time ./copy ./move2kube.mp4 ./move2kube_copy.mp4; } 2> $LOGS_DIR/time.txt
cd - || exit 1


lang=c
wl=sudoku
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./sudoku input-64.txt > "$LOGS_DIR/perfrecord.log"
syscount -c ./sudoku input-64.txt > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./sudoku input-64.txt > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./sudoku input-64.txt > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./sudoku input-64.txt > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./sudoku input-64.txt 2> "$LOGS_DIR/ptrace.txt"
{ time ./sudoku input-64.txt; } 2> $LOGS_DIR/time.txt
cd - || exit 1

lang=c
wl=graph
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./graph graph-250000-edges.txt > "$LOGS_DIR/perfrecord.log"
syscount -c ./graph graph-250000-edges.txt > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./graph graph-250000-edges.txt > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./graph graph-250000-edges.txt > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./graph graph-250000-edges.txt > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./graph graph-250000-edges.txt 2> "$LOGS_DIR/ptrace.txt"
{ time ./graph graph-250000-edges.txt; } 2> $LOGS_DIR/time.txt
cd - || exit 1


lang=c
wl=simd
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./simd 256 256 100 > "$LOGS_DIR/perfrecord.log"
syscount -c ./simd 256 256 100 > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./simd 256 256 100 > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./simd 256 256 100 > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./simd 256 256 100 > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./simd 256 256 100 2> "$LOGS_DIR/ptrace.txt"
{ time ./simd 256 256 100; } 2> $LOGS_DIR/time.txt

lang=c
wl=nosimd
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./nosimd 256 256 100 > "$LOGS_DIR/perfrecord.log"
syscount -c ./nosimd 256 256 100 > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./nosimd 256 256 100 > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./nosimd 256 256 100 > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./nosimd 256 256 100 > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./nosimd 256 256 100 2> "$LOGS_DIR/ptrace.txt"
{ time ./nosimd 256 256 100; } 2> $LOGS_DIR/time.txt
cd - || exit 1

lang=go
wl=sort
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./sort > "$LOGS_DIR/perfrecord.log"
syscount -c ./sort > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./sort > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./sort > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./sort > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./sort 2> "$LOGS_DIR/ptrace.txt"
{ time ./sort; } 2> $LOGS_DIR/time.txt
cd - || exit 1

lang=go
wl=copyfile
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./copy ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfrecord.log"
syscount -c ./copy ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./copy ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./copy ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./copy ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./copy ./move2kube.mp4 ./move2kube_copy.mp4 2> "$LOGS_DIR/ptrace.txt"
{ time ./copy ./move2kube.mp4 ./move2kube_copy.mp4; } 2> $LOGS_DIR/time.txt
cd - || exit 1

lang=go
wl=sudoku
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./sudoku input-64.txt > "$LOGS_DIR/perfrecord.log"
syscount -c ./sudoku input-64.txt > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./sudoku input-64.txt > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./sudoku input-64.txt > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./sudoku input-64.txt > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./sudoku input-64.txt 2> "$LOGS_DIR/ptrace.txt"
{ time ./sudoku input-64.txt; } 2> $LOGS_DIR/time.txt
cd - || exit 1

lang=go
wl=graph
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./graph graph-250000-edges.txt > "$LOGS_DIR/perfrecord.log"
syscount -c ./graph graph-250000-edges.txt > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./graph graph-250000-edges.txt > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./graph graph-250000-edges.txt > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./graph graph-250000-edges.txt > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./graph graph-250000-edges.txt 2> "$LOGS_DIR/ptrace.txt"
{ time ./graph graph-250000-edges.txt; } 2> $LOGS_DIR/time.txt
cd - || exit 1

lang=go
wl=nosimd
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
wl=simd
workload=$lang-$wl

cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./nosimd 256 256 100 > "$LOGS_DIR/perfrecord.log"
syscount -c ./nosimd 256 256 100 > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./nosimd 256 256 100 > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./nosimd 256 256 100 > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" ./nosimd 256 256 100 > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s ./nosimd 256 256 100 2> "$LOGS_DIR/ptrace.txt"
{ time ./nosimd 256 256 100; } 2> $LOGS_DIR/time.txt
cd - || exit 1

lang=py
wl=sort
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" python3 ./sort.py > "$LOGS_DIR/perfrecord.log"
syscount -c python3 ./sort.py > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" python3 ./sort.py > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord python3 ./sort.py > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" python3 ./sort.py > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s python3 ./sort.py 2> "$LOGS_DIR/ptrace.txt"
{ time python3 ./sort.py; } 2> $LOGS_DIR/time.txt
cd - || exit 1

lang=py
wl=copyfile
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" python3 ./copy.py ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfrecord.log"
syscount -c python3 ./copy.py ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" python3 ./copy.py ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord python3 ./copy.py ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" python3 ./copy.py ./move2kube.mp4 ./move2kube_copy.mp4 > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s python3 ./copy.py ./move2kube.mp4 ./move2kube_copy.mp4 2> "$LOGS_DIR/ptrace.txt"
{ time python3 ./copy.py ./move2kube.mp4 ./move2kube_copy.mp4; } 2> $LOGS_DIR/time.txt
cd - || exit 1

lang=py
wl=sudoku
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" python3 sudoku.py input-64.txt > "$LOGS_DIR/perfrecord.log"
syscount -c python3 sudoku.py input-64.txt > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" python3 sudoku.py input-64.txt > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord python3 sudoku.py input-64.txt > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" python3 sudoku.py input-64.txt > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s python3 sudoku.py input-64.txt 2> "$LOGS_DIR/ptrace.txt"
{ time python3 sudoku.py input-64.txt; } 2> $LOGS_DIR/time.txt
cd - || exit 1


lang=py
wl=graph
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" python3 graph.py graph-250000-edges.txt > "$LOGS_DIR/perfrecord.log"
syscount -c python3 graph.py graph-250000-edges.txt > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" python3 graph.py graph-250000-edges.txt > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord python3 graph.py graph-250000-edges.txt > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" python3 graph.py graph-250000-edges.txt > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s python3 graph.py graph-250000-edges.txt 2> "$LOGS_DIR/ptrace.txt"
{ time python3 graph.py graph-250000-edges.txt; } 2> $LOGS_DIR/time.txt
cd - || exit 1

lang=py
wl=simd
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

cd ./$workload || exit 1
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" python3 ./simd.py 256 256 100 > "$LOGS_DIR/perfrecord.log"
syscount -c python3 ./simd.py 256 256 100 > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" python3 ./simd.py 256 256 100 > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord python3 ./simd.py 256 256 100 > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" python3 ./simd.py 256 256 100 > "$LOGS_DIR/perfmemrecord.log"
perf trace -s python3 ./simd.py 256 256 100 2> "$LOGS_DIR/ptrace.txt"
{ time python3 ./simd.py 256 256 100; } 2> $LOGS_DIR/time.txt

lang=py
wl=nosimd
OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload=$lang-$wl

perf record -F 99 -o "$OUTPUT_DIR/perfrecord" python3 ./nosimd.py 256 256 100 > "$LOGS_DIR/perfrecord.log"
syscount -c python3 ./nosimd.py 256 256 100 > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" python3 ./nosimd.py 256 256 100 > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord python3 ./nosimd.py 256 256 100 > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" python3 ./nosimd.py 256 256 100 > "$LOGS_DIR/perfmemrecord.log"
perf trace -s python3 ./nosimd.py 256 256 100 2> "$LOGS_DIR/ptrace.txt"
{ time python3 ./nosimd.py 256 256 100; } 2> $LOGS_DIR/time.txt
cd - || exit 1

echo 'done'


