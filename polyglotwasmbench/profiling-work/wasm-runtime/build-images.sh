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

workload_type=container-wasm

# rust

workload_name=rust-sort
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload:latest .
cd - || exit 1

workload_name=rust-copyfile
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload:latest .
cd - || exit 1

workload_name=rust-fileserver
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload:latest .
cd - || exit 1

workload_name=rust-graph
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload:latest .
cd - || exit 1

workload_name=rust-simd
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload:latest -f Dockerfile.simd .
cd - || exit 1

workload_name=rust-simd
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload-without:latest -f Dockerfile.nosimd .
cd - || exit 1

workload_name=rust-sudoku
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload:latest .
cd - || exit 1


## c

workload_name=c-sort
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload:latest .
cd - || exit 1

workload_name=c-copyfile
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload:latest .
cd - || exit 1

workload_name=c-fileserver
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload:latest .
cd - || exit 1

workload_name=c-graph
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload:latest .
cd - || exit 1

workload_name=c-simd
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload:latest -f Dockerfile.simd .
cd - || exit 1

workload_name=c-simd
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload-without:latest -f Dockerfile.nosimd .
cd - || exit 1


workload_name=c-sudoku
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload:latest .
cd - || exit 1


# go


workload_name=go-sort
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload:latest .
cd - || exit 1

workload_name=go-copyfile
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload:latest .
cd - || exit 1


workload_name=go-graph
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload:latest .
cd - || exit 1


workload_name=go-simd
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload-without:latest -f Dockerfile.nosimd .
cd - || exit 1

workload_name=go-sudoku
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload:latest .
cd - || exit 1


# py


workload_name=py-sort
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload:latest .
cd - || exit 1

workload_name=py-copyfile
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload:latest .
cd - || exit 1

workload_name=py-graph
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload:latest .
cd - || exit 1

# workload_name=py-simd
# workload=$workload_type-$workload_name
# echo $workload
# cd ./$workload_name || exit 1
# podman build -t $container_namespace/$workload:latest -f Dockerfile.simd .
# cd - || exit 1

# workload_name=py-simd
# workload=$workload_type-$workload_name
# echo $workload
# cd ./$workload_name || exit 1
# podman build -t $container_namespace/$workload-without:latest -f Dockerfile.nosimd .
# cd - || exit 1


workload_name=py-sudoku
workload=$workload_type-$workload_name
echo $workload
cd ./$workload_name || exit 1
podman build -t $container_namespace/$workload:latest .
cd - || exit 1

