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

### Error handling ###
set -euo pipefail

### Print out usage information ###
script_usage() { cat <<EOT
usage:   ${SCRIPT_NAME} [-v] [-h]
example: container_namespace="us.icr.io/polyglotwasmbench" wasmtime_original_loc="/usr/local/bin/crun-wasmtime-original" wasmtime_socket_loc="/usr/local/bin/crun-wasmtime-socket" iter=1 ./${SCRIPT_NAME} -v

arguments (optional):
-v:      Be verbose
-h:      Print this help
EOT
}

### Print out information if in verbose mode ###
echo_verbose() { if [ ${ARGUMENT_VERBOSE} -eq 1 ]; then echo "${@}"; fi }

### Print out information on error channel ###
echo_error() { echo "${@}" >&2; }

### handling errors ###
error_handling() {
  if [ "${RETURN_CODE}" -eq 0 ]; then
    echo_verbose "${SCRIPT_NAME} successfull!"
  else
    echo_error "${SCRIPT_NAME} aborted, reason: ${EXIT_REASON}"
    echo; script_usage
  fi
  exit "${RETURN_CODE}"
}
trap "error_handling" EXIT HUP INT QUIT TERM
RETURN_CODE=0
EXIT_REASON="Finished!"


### Default script variables ###
ARGUMENT_VERBOSE=0
SCRIPT_NAME=$(basename ${0})

### Get the arguments used at script execution ###
while [ ${#} -ne 0 ]; do
  case "${1}" in
    -v|--verbose) ARGUMENT_VERBOSE=1 ;;
    -h|--help)    script_usage; exit ;;
  esac;
  shift
done

### throw error if iter is not set ###
if [ -z "$iter" ]; then
  echo "iter is empty or not set. Please set it the itertion number."
  exit 1
fi

### throw error if container_namespace is not set ###
if [ -z "$container_namespace" ]; then
  echo "container_namespace is empty or not set. Please set it to the container registry/namespace format. e.g. : us.icr.io/polyglotwasmbench"
  exit 1
fi

### throw error if wasmtime_original_loc is not set ###
if [ -z "$wasmtime_original_loc" ]; then
  echo "wasmtime_original_loc is empty or not set. Please set it to the crun wastime binary."
  exit 1
fi

### throw error if wasmtime_socket_loc is not set ###
if [ -z "$wasmtime_socket_loc" ]; then
  echo "wasmtime_socket_loc is empty or not set. Please set it to the crun wastime socket-only binary."
  exit 1
fi

echo "Benchmark script running..."

cd ./polyglotwasmbench/profiling-work/native-code || exit 1
echo "################ profile workloads as native binaries on bare metal ################"
bash +x profile.sh
echo "################################"
cd -

cd ./polyglotwasmbench/profiling-work/native-code || exit 1
echo "################ profile workloads as native binaries in container (crun-plain + gvisor) ################"
bash +x profile-images.sh
echo "################################"
cd -

cd ./polyglotwasmbench/profiling-work/wasm-runtime || exit 1
echo "################ profile workloads as wasm modules in wasmtime runtime ################"
bash +x profile.sh
echo "################################"
cd -

cp $wasmtime_original_loc /usr/local/bin/crun-wasmtime

cd ./polyglotwasmbench/profiling-work/wasm-runtime || exit 1
echo "################ profile workloads as wasm modules in container with wasmtime runtime ################"
bash +x profile-images.sh
echo "################################"
cd -

cd ./polyglotwasmbench/profiling-work/sdk-wrappers || exit 1
echo "################ profile workloads as wrapper binaries + wasm modules ################"
bash +x profile.sh
echo "################################"
cd -

cd ./polyglotwasmbench/profiling-work/sdk-wrappers || exit 1
echo "################ profile workloads as wrapper binaries + wasm modules in container (crun-plain + gvisor) ################"
bash +x profile-images.sh
echo "################################"
cd -

cp $wasmtime_socket_loc /usr/local/bin/crun-wasmtime

cd ./polyglotwasmbench/profiling-work/fileserver_benchmark || exit 1
echo "################ profile file server workloads ################"
bash +x benchmark.sh
echo "################################"
cd -

echo "benchmark finished and results available at ./profiling_results_$iter"

