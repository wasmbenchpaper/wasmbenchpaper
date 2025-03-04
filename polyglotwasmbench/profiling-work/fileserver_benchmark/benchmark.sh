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

echo 'BENCHMARK FILESERVERS ON BAREMETAL'

folder=fileserver

# only rust supported.
langs=("rust")

# move the crun-wasmtme
for lang in "${langs[@]}"; do

      workload=native-$lang-fileserver
      OUTPUT_DIR="../../../profiling_results_$iter/native/$lang/$folder"
      OUTPUT_DIR=$(realpath $OUTPUT_DIR)
      LOGS_DIR="$OUTPUT_DIR/logs"
      mkdir -p $LOGS_DIR
      echo $workload
      cd ./native-code/$lang-fileserver || exit 1
      perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./fileserver 0.0.0.0 8080  > "$LOGS_DIR/perfrecord.log" &
      bash ./curl.sh
      cd -

      echo $workload
      cd ./native-code/$lang-fileserver || exit 1
      syscount -c ./fileserver 0.0.0.0 8080  > "$LOGS_DIR/syscount.log" &
      bash ./curl.sh
      cd -

      echo $workload
      cd ./native-code/$lang-fileserver || exit 1
      perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./fileserver 0.0.0.0 8080  > "$LOGS_DIR/perfstat.log" &
      bash ./curl.sh
      cd -

      echo $workload
      cd ./native-code/$lang-fileserver || exit 1
      perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./fileserver 0.0.0.0 8080  > "$LOGS_DIR/perfmemrecord.log" &
      bash ./curl.sh
      cd -

      echo $workload
      cd ./native-code/$lang-fileserver || exit 1
      perf record -F 99 -g -o $OUTPUT_DIR/perfmemrecordF ./fileserver 0.0.0.0 8080  > "$LOGS_DIR/perfmemrecordF.log" &
      bash ./curl.sh
      cd -
      
      echo $workload
      cd ./native-code/$lang-fileserver || exit 1
      { time ./fileserver 0.0.0.0 8080; } 2> $LOGS_DIR/time.txt &
      bash ./curl.sh
      cd -

      echo $workload
      cd ./native-code/$lang-fileserver || exit 1
      perf trace -s  ./fileserver 0.0.0.0 8080 2> $LOGS_DIR/peftrace.txt &
      bash ./curl.sh
      cd -

    workload=wasm-$lang-fileserver

      # workload=native-$lang-fileserver
      OUTPUT_DIR="../../../profiling_results_$iter/wasm/$lang/$folder"
      OUTPUT_DIR=$(realpath $OUTPUT_DIR)
      LOGS_DIR="$OUTPUT_DIR/logs"
      mkdir -p $LOGS_DIR
      echo $workload
      cd ./wasm-runtime/$lang-fileserver || exit 1
      perf record -F 99 -o "$OUTPUT_DIR/perfrecord" wasmtime run --tcplisten 0.0.0.0:8080 --dir=. --env 'LISTEN_FDS=1' fileserver.wasm 0.0.0.0 8080  > "$LOGS_DIR/perfrecord.log" &
      bash ./curl.sh
      cd -

      echo $workload
      cd ./wasm-runtime/$lang-fileserver || exit 1
      syscount -c wasmtime run --tcplisten 0.0.0.0:8080 --dir=. --env 'LISTEN_FDS=1' fileserver.wasm 0.0.0.0 8080  > "$LOGS_DIR/syscount.log" &
      bash ./curl.sh
      cd -

      echo $workload
      cd ./wasm-runtime/$lang-fileserver || exit 1
      perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" wasmtime run --tcplisten 0.0.0.0:8080 --dir=. --env 'LISTEN_FDS=1' fileserver.wasm 0.0.0.0 8080  > "$LOGS_DIR/perfstat.log" &
      bash ./curl.sh
      cd -

      echo $workload
      cd ./wasm-runtime/$lang-fileserver || exit 1
      perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord wasmtime run --tcplisten 0.0.0.0:8080 --dir=. --env 'LISTEN_FDS=1' fileserver.wasm 0.0.0.0 8080  > "$LOGS_DIR/perfmemrecord.log" &
      bash ./curl.sh
      cd -

      echo $workload
      cd ./wasm-runtime/$lang-fileserver || exit 1
      perf record -F 99 -g -o $OUTPUT_DIR/perfmemrecordF wasmtime run --tcplisten 0.0.0.0:8080 --dir=. --env 'LISTEN_FDS=1' fileserver.wasm 0.0.0.0 8080  > "$LOGS_DIR/perfmemrecordF.log" &
      bash ./curl.sh
      cd -

      echo $workload
      cd ./wasm-runtime/$lang-fileserver || exit 1
      { time wasmtime run --tcplisten 0.0.0.0:8080 --dir=. --env 'LISTEN_FDS=1' fileserver.wasm 0.0.0.0 8080; } 2> $LOGS_DIR/time.txt &
      bash ./curl.sh
      cd -

      echo $workload
      cd ./wasm-runtime/$lang-fileserver || exit 1
      perf trace -s  wasmtime run --tcplisten 0.0.0.0:8080 --dir=. --env 'LISTEN_FDS=1' fileserver.wasm 0.0.0.0 8080 2> $LOGS_DIR/peftrace.txt &
      bash ./curl.sh
      cd -

    # move the wasmtime and do it
    workload=container-wasm-$lang-fileserver
    runtime=crun-wasmtime
      OUTPUT_DIR="../../../profiling_results_$iter/crun_wasm/crun-wasmtime/$lang/$folder"
      OUTPUT_DIR=$(realpath $OUTPUT_DIR)
      LOGS_DIR="$OUTPUT_DIR/logs"
      mkdir -p $LOGS_DIR

      echo $workload
      perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/$workload:latest > "$LOGS_DIR/perfrecord.log" &
      bash ./curl.sh

      echo $workload
      syscount -c podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/$workload:latest > "$LOGS_DIR/syscount.log" &
      bash ./curl.sh

      cd ./wasm-runtime/$lang-fileserver || exit 1
      perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/$workload:latest > "$LOGS_DIR/perfstat.log" &
      bash ./curl.sh

      cd ./wasm-runtime/$lang-fileserver || exit 1
      perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecord.log" &
      bash ./curl.sh

      cd ./wasm-runtime/$lang-fileserver || exit 1
      perf record -F 99 -g -o $OUTPUT_DIR/perfmemrecordF podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecordF.log" &
      bash ./curl.sh

      cd ./wasm-runtime/$lang-fileserver || exit 1
      { time podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt &
      bash ./curl.sh

      cd ./wasm-runtime/$lang-fileserver || exit 1
      perf trace -s  podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/$workload:latest 2> $LOGS_DIR/peftrace.txt &
      bash ./curl.sh

    workload=native-$lang-fileserver
    runtime=crun-plain

      OUTPUT_DIR="../../../profiling_results_$iter/crun_native/$runtime/$lang/$folder"
      OUTPUT_DIR=$(realpath $OUTPUT_DIR)
      LOGS_DIR="$OUTPUT_DIR/logs"
      mkdir -p $LOGS_DIR
      echo $workload
      perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/$workload:latest > "$LOGS_DIR/perfrecord.log" &
      bash ./curl.sh

      echo $workload
      syscount -c podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/$workload:latest > "$LOGS_DIR/syscount.log" &
      bash ./curl.sh

      echo $workload
      perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/$workload:latest > "$LOGS_DIR/perfstat.log" &
      bash ./curl.sh

      echo $workload
      perf mem record -F 99 -o "$OUTPUT_DIR/perfmemrecord" podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/$workload:latest  > "$LOGS_DIR/perfmemrecord.log" &
      bash ./curl.sh

      echo $workload
      perf record -F 99 -g -o $OUTPUT_DIR/perfmemrecordF podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecordF.log" &
      bash ./curl.sh

      echo $workload
      { time podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt &
      bash ./curl.sh

      echo $workload
      perf trace -s  podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/$workload:latest 2> $LOGS_DIR/peftrace.txt &
      bash ./curl.sh

    runtime=runsc

      OUTPUT_DIR="../../../profiling_results_$iter/crun_native/$runtime/$lang/$folder"
      OUTPUT_DIR=$(realpath $OUTPUT_DIR)
      LOGS_DIR="$OUTPUT_DIR/logs"
      mkdir -p $LOGS_DIR
      echo $workload
      perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/$workload:latest > "$LOGS_DIR/perfrecord.log" &
      bash ./curl.sh

      echo $workload
      syscount -c podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/$workload:latest > "$LOGS_DIR/syscount.log" &
      bash ./curl.sh

      echo $workload
      perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/$workload:latest > "$LOGS_DIR/perfstat.log" &
      bash ./curl.sh

      echo $workload
      perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecord.log" &
      bash ./curl.sh

      echo $workload
      perf record -F 99 -g -o $OUTPUT_DIR/perfmemrecordF podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/$workload:latest > "$LOGS_DIR/perfmemrecordF.log" &
      bash ./curl.sh

      echo $workload
      { time podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/$workload:latest; } 2> $LOGS_DIR/time.txt &
      bash ./curl.sh

      echo $workload
      perf trace -s  podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/$workload:latest 2> $LOGS_DIR/peftrace.txt &
      bash ./curl.sh

    workload=sdkwrapper-$lang-fileserver

      OUTPUT_DIR="../../../profiling_results_$iter/sdk/$lang/$folder"
      OUTPUT_DIR=$(realpath $OUTPUT_DIR)
      LOGS_DIR="$OUTPUT_DIR/logs"
      mkdir -p $LOGS_DIR
      echo $workload
      cd $project_loc/polyglotwasmbench/sdk-wrappers/profiling-work/$lang-fileserver || exit 1
      perf record -F 99 -o "$OUTPUT_DIR/perfrecord" ./wrapper ./main.wasm 0.0.0.0 8080  > "$LOGS_DIR/perfrecord.log" &
      bash ./curl.sh
      cd -

      echo $workload
      cd $project_loc/polyglotwasmbench/sdk-wrappers/profiling-work/$lang-fileserver || exit 1
      syscount -c ./wrapper ./main.wasm 0.0.0.0 8080  > "$LOGS_DIR/syscount.log" &
      bash ./curl.sh
      cd -

      echo $workload
      cd $project_loc/polyglotwasmbench/sdk-wrappers/profiling-work/$lang-fileserver || exit 1
      perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" ./wrapper ./main.wasm 0.0.0.0 8080  > "$LOGS_DIR/perfstat.log" &
      bash ./curl.sh
      cd -

      echo $workload
      cd $project_loc/polyglotwasmbench/sdk-wrappers/profiling-work/$lang-fileserver || exit 1
      perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord ./wrapper ./main.wasm 0.0.0.0 8080  > "$LOGS_DIR/perfmemrecord.log" &
      bash ./curl.sh
      cd -

      echo $workload
      cd $project_loc/polyglotwasmbench/sdk-wrappers/profiling-work/$lang-fileserver || exit 1
      perf record -F 99 -g -o $OUTPUT_DIR/perfmemrecordF ./wrapper ./main.wasm 0.0.0.0 8080  > "$LOGS_DIR/perfmemrecordF.log" &
      bash ./curl.sh
      cd -

      echo $workload
      cd $project_loc/polyglotwasmbench/sdk-wrappers/profiling-work/$lang-fileserver || exit 1
      { time ./wrapper ./main.wasm 0.0.0.0 8080; } 2> $LOGS_DIR/time.txt &
      bash ./curl.sh
      cd -

      echo $workload
      cd $project_loc/polyglotwasmbench/sdk-wrappers/profiling-work/$lang-fileserver || exit 1
      perf trace -s  ./wrapper ./main.wasm 0.0.0.0 8080 2> $LOGS_DIR/peftrace.txt &
      bash ./curl.sh
      cd -

    workload=sdkwrapper-$lang-fileserver-container
    runtime=crun-plain
      OUTPUT_DIR="../../../profiling_results_$iter/crun_sdk/$runtime/$lang/$folder"
      OUTPUT_DIR=$(realpath $OUTPUT_DIR)
      LOGS_DIR="$OUTPUT_DIR/logs"
      mkdir -p $LOGS_DIR

      echo $workload
      perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/sdkwrapper-$lang-fileserver:latest > "$LOGS_DIR/perfrecord.log" &
      bash ./curl.sh
      echo $workload
      syscount -c podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/sdkwrapper-$lang-fileserver:latest > "$LOGS_DIR/syscount.log" &
      bash ./curl.sh
      echo $workload
      perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/sdkwrapper-$lang-fileserver:latest > "$LOGS_DIR/perfstat.log" &
      bash ./curl.sh
      echo $workload
      perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/sdkwrapper-$lang-fileserver:latest > "$LOGS_DIR/perfmemrecord.log" &
      bash ./curl.sh
      echo $workload
      perf record -F 99 -g -o $OUTPUT_DIR/perfmemrecordF podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/sdkwrapper-$lang-fileserver:latest > "$LOGS_DIR/perfmemrecordF.log" &
      bash ./curl.sh
      echo $workload
      { time podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/sdkwrapper-$lang-fileserver:latest; } 2> $LOGS_DIR/time.txt &
      bash ./curl.sh
      echo $workload
      perf trace -s  podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/sdkwrapper-$lang-fileserver:latest 2> $LOGS_DIR/peftrace.txt &
      bash ./curl.sh
    runtime=runsc

      OUTPUT_DIR="../../../profiling_results_$iter/crun_sdk/$runtime/$lang/$folder"
      OUTPUT_DIR=$(realpath $OUTPUT_DIR)
      LOGS_DIR="$OUTPUT_DIR/logs"
      mkdir -p $LOGS_DIR
      echo $workload
      perf record -F 99 -o "$OUTPUT_DIR/perfrecord" podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/sdkwrapper-$lang-fileserver:latest > "$LOGS_DIR/perfrecord.log" &
      bash ./curl.sh
      echo $workload
      syscount -c podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/sdkwrapper-$lang-fileserver:latest > "$LOGS_DIR/syscount.log" &
      bash ./curl.sh
      echo $workload
      perf stat -d --field-separator ',' -o "$OUTPUT_DIR/perfstat" podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/sdkwrapper-$lang-fileserver:latest > "$LOGS_DIR/perfstat.log" &
      bash ./curl.sh
      echo $workload
      perf mem record -F 99 -o $OUTPUT_DIR/perfmemrecord podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/sdkwrapper-$lang-fileserver:latest > "$LOGS_DIR/perfmemrecord.log" &
      bash ./curl.sh
      echo $workload
      perf record -F 99 -g -o $OUTPUT_DIR/perfmemrecordF podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/sdkwrapper-$lang-fileserver:latest > "$LOGS_DIR/perfmemrecordF.log" &
      bash ./curl.sh
      echo $workload
      { time podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/sdkwrapper-$lang-fileserver:latest; } 2> $LOGS_DIR/time.txt &
      bash ./curl.sh
      echo $workload
      perf trace -s  podman run --rm --runtime=/usr/local/bin/$runtime --publish 8080:8080 $container_namespace/sdkwrapper-$lang-fileserver:latest 2> $LOGS_DIR/peftrace.txt &
      bash ./curl.sh
done
