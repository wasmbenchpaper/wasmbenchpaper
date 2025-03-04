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

echo 'BENCHMARK WASM IN CONTAINERS'

if [ -z "$iter" ]; then
  echo "iter is empty or not set."
  exit 1
fi

workload_type=container-wasm



runtime=crun-wasmtime
lang=rust
wl=sort
OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/$runtime/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload_name=$lang-$wl
workload=$workload_type-$workload_name
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfrecord.log"
syscount -c podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest 2> $LOGS_DIR/ptrace.txt
{ time podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt

runtime=crun-wasmtime
lang=rust
wl=copyfile
OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/$runtime/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload_name=$lang-$wl
workload=$workload_type-$workload_name
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfrecord.log"
syscount -c podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest 2> $LOGS_DIR/ptrace.txt
{ time podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt


runtime=crun-wasmtime
lang=rust
wl=graph
OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/$runtime/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload_name=$lang-$wl
workload=$workload_type-$workload_name
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfrecord.log"
syscount -c podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest 2> $LOGS_DIR/ptrace.txt
{ time podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt


runtime=crun-wasmtime
lang=rust
wl=simd
OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/$runtime/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload_name=$lang-$wl
workload=$workload_type-$workload_name
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfrecord.log"
syscount -c podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest 2> $LOGS_DIR/ptrace.txt
{ time podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt


# no simd
runtime=crun-wasmtime
lang=rust
wl=nosimd
OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/$runtime/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
wl=simd
workload_name=$lang-$wl
workload=$workload_type-$workload_name
perf record -F 99 -o "$OUTPUT_DIR/perfrecord-without" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload-without:latest > "$LOGS_DIR/perfrecord-without.log"
syscount -c podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload-without:latest > "$LOGS_DIR/syscount-without.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat-without" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload-without:latest > "$LOGS_DIR/perfstat-without.log"
perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord-without" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload-without:latest > "$LOGS_DIR/perfmemrecord-without.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload-without:latest > "$LOGS_DIR/perfmemrecordF-without.log"
perf trace -s podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest 2> $LOGS_DIR/ptrace.txt
{ time podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt

runtime=crun-wasmtime
lang=rust
wl=sudoku
OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/$runtime/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload_name=$lang-$wl
workload=$workload_type-$workload_name
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfrecord.log"
syscount -c podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest 2> $LOGS_DIR/ptrace.txt
{ time podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt


## c

runtime=crun-wasmtime
lang=c
wl=sort
OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/$runtime/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload_name=$lang-$wl
workload=$workload_type-$workload_name
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfrecord.log"
syscount -c podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest 2> $LOGS_DIR/ptrace.txt
{ time podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt


runtime=crun-wasmtime
lang=c
wl=copyfile
OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/$runtime/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload_name=$lang-$wl
workload=$workload_type-$workload_name
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfrecord.log"
syscount -c podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest 2> $LOGS_DIR/ptrace.txt
{ time podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt



runtime=crun-wasmtime
lang=c
wl=graph
OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/$runtime/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload_name=$lang-$wl
workload=$workload_type-$workload_name
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfrecord.log"
syscount -c podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest 2> $LOGS_DIR/ptrace.txt
{ time podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt


runtime=crun-wasmtime
lang=c
wl=simd
OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/$runtime/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload_name=$lang-$wl
workload=$workload_type-$workload_name
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfrecord.log"
syscount -c podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest 2> $LOGS_DIR/ptrace.txt
{ time podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt


runtime=crun-wasmtime
lang=c
wl=nosimd
OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/$runtime/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
wl=simd
workload_name=$lang-$wl
workload=$workload_type-$workload_name
perf record -F 99 -o "$OUTPUT_DIR/perfrecord-without" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload-without:latest > "$LOGS_DIR/perfrecord-without.log"
syscount -c podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload-without:latest > "$LOGS_DIR/syscount-without.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat-without" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload-without:latest > "$LOGS_DIR/perfstat-without.log"
perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord-without" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload-without:latest > "$LOGS_DIR/perfmemrecord-without.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload-without:latest > "$LOGS_DIR/perfmemrecordF-without.log"
perf trace -s podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest 2> $LOGS_DIR/ptrace.txt
{ time podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt


runtime=crun-wasmtime
lang=c
wl=sudoku
OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/$runtime/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload_name=$lang-$wl
workload=$workload_type-$workload_name
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfrecord.log"
syscount -c podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest 2> $LOGS_DIR/ptrace.txt
{ time podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt



# go

runtime=crun-wasmtime
lang=go
wl=sort
OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/$runtime/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload_name=$lang-$wl
workload=$workload_type-$workload_name
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfrecord.log"
syscount -c podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest 2> $LOGS_DIR/ptrace.txt
{ time podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt

runtime=crun-wasmtime
lang=go
wl=copyfile
OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/$runtime/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload_name=$lang-$wl
workload=$workload_type-$workload_name
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfrecord.log"
syscount -c podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest 2> $LOGS_DIR/ptrace.txt
{ time podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt


runtime=crun-wasmtime
lang=go
wl=graph
OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/$runtime/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload_name=$lang-$wl
workload=$workload_type-$workload_name
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfrecord.log"
syscount -c podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest 2> $LOGS_DIR/ptrace.txt
{ time podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt

runtime=crun-wasmtime
lang=go
wl=nosimd
OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/$runtime/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
wl=simd
workload_name=$lang-$wl
workload=$workload_type-$workload_name
perf record -F 99 -o "$OUTPUT_DIR/perfrecord-without" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload-without:latest > "$LOGS_DIR/perfrecord-without.log"
syscount -c podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload-without:latest > "$LOGS_DIR/syscount-without.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat-without" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload-without:latest > "$LOGS_DIR/perfstat-without.log"
perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord-without" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload-without:latest > "$LOGS_DIR/perfmemrecord-without.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload-without:latest > "$LOGS_DIR/perfmemrecordF-without.log"
perf trace -s podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest 2> $LOGS_DIR/ptrace.txt
{ time podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt

runtime=crun-wasmtime
lang=go
wl=sudoku
OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/$runtime/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload_name=$lang-$wl
workload=$workload_type-$workload_name
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfrecord.log"
syscount -c podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest 2> $LOGS_DIR/ptrace.txt
{ time podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt



# py

runtime=crun-wasmtime
lang=py
wl=sort
OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/$runtime/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload_name=$lang-$wl
workload=$workload_type-$workload_name
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfrecord.log"
syscount -c podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest 2> $LOGS_DIR/ptrace.txt
{ time podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt

runtime=crun-wasmtime
lang=py
wl=copyfile
OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/$runtime/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload_name=$lang-$wl
workload=$workload_type-$workload_name
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfrecord.log"
syscount -c podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest 2> $LOGS_DIR/ptrace.txt
{ time podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt


runtime=crun-wasmtime
lang=py
wl=graph
OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/$runtime/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload_name=$lang-$wl
workload=$workload_type-$workload_name
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfrecord.log"
syscount -c podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest 2> $LOGS_DIR/ptrace.txt
{ time podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt


runtime=crun-wasmtime
lang=py
wl=sudoku
OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/$runtime/$lang/$wl"
OUTPUT_DIR=$(realpath $OUTPUT_DIR)
LOGS_DIR="$OUTPUT_DIR/logs"
mkdir -p $LOGS_DIR
echo $lang-$wl
workload_name=$lang-$wl
workload=$workload_type-$workload_name
perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfrecord.log"
syscount -c podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/syscount.log"
perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfstat.log"
perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecord.log"
perf record -F 99 -g -o "$OUTPUT_DIR/perfmemrecordF" podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecordF.log"
perf trace -s podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest 2> $LOGS_DIR/ptrace.txt
{ time podman run --rm --runtime=/usr/local/bin/$runtime $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt

echo "done"
