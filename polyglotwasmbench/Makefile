all-wrapper-images: buildstage wasmlib wrapperlib sdk-wrapper-c-copyfile sdk-wrapper-c-sort sdk-wrapper-go-copyfile sdk-wrapper-go-sort sdk-wrapper-py-copyfile sdk-wrapper-py-sort sdk-wrapper-rust-copyfile sdk-wrapper-rust-sort sdk-wrapper-rust-httpserver sdk-wrapper-rust-echoserver

all-wasm-images: wasm-c-copyfile wasm-c-sort wasm-go-copyfile wasm-go-sort wasm-rust-copyfile wasm-rust-sort wasm-rust-httpserver

wasm-c-copyfile:
	docker build -t us.icr.io/polyglotwasmbench/wasm-c-copyfile:latest -f Dockerfile.wasm-c-copyfile .
	docker push us.icr.io/polyglotwasmbench/wasm-c-copyfile:latest

wasm-c-sort:
	docker build -t us.icr.io/polyglotwasmbench/wasm-c-sort:latest -f Dockerfile.wasm-c-sort .
	docker push us.icr.io/polyglotwasmbench/wasm-c-sort:latest

wasm-go-copyfile:
	docker build -t us.icr.io/polyglotwasmbench/wasm-go-copyfile:latest -f Dockerfile.wasm-go-copyfile .
	docker push us.icr.io/polyglotwasmbench/wasm-go-copyfile:latest

wasm-go-sort:
	docker build -t us.icr.io/polyglotwasmbench/wasm-go-sort:latest -f Dockerfile.wasm-go-sort .
	docker push us.icr.io/polyglotwasmbench/wasm-go-sort:latest

wasm-rust-copyfile:
	docker build -t us.icr.io/polyglotwasmbench/wasm-rust-copyfile:latest -f Dockerfile.wasm-rust-copyfile .
	docker push us.icr.io/polyglotwasmbench/wasm-rust-copyfile:latest

wasm-rust-sort:
	docker build -t us.icr.io/polyglotwasmbench/wasm-rust-sort:latest -f Dockerfile.wasm-rust-sort .
	docker push us.icr.io/polyglotwasmbench/wasm-rust-sort:latest

wasm-rust-httpserver:
	docker build -t us.icr.io/polyglotwasmbench/wasm-rust-httpserver:latest -f Dockerfile.wasm-rust-httpserver .
	docker push us.icr.io/polyglotwasmbench/wasm-rust-httpserver:latest

buildstage:
	docker build -t us.icr.io/polyglotwasmbench/sdk-wrapper-buildstage-time -f Dockerfile.buildstage .
	docker push us.icr.io/polyglotwasmbench/sdk-wrapper-buildstage-time

wasmlib:
	docker build -t us.icr.io/polyglotwasmbench/sdk-wasm-library-time -f Dockerfile.wasm_library .
	docker push us.icr.io/polyglotwasmbench/sdk-wasm-library-time

wrapperlib:
	docker build -t us.icr.io/polyglotwasmbench/sdk-wrapper-library-time -f Dockerfile.wrapper_library .
	docker push us.icr.io/polyglotwasmbench/sdk-wrapper-library-time

sdk-wrapper-c-copyfile:
	docker build -t us.icr.io/polyglotwasmbench/sdk-wrapper-c-copyfile-time:latest -f Dockerfile.sdk-wrapper-c-copyfile .
	docker push us.icr.io/polyglotwasmbench/sdk-wrapper-c-copyfile-time:latest


sdk-wrapper-c-sort:
	docker build -t us.icr.io/polyglotwasmbench/sdk-wrapper-c-sort-time:latest -f Dockerfile.sdk-wrapper-c-sort .
	docker push us.icr.io/polyglotwasmbench/sdk-wrapper-c-sort-time:latest


sdk-wrapper-go-copyfile:
	docker build -t us.icr.io/polyglotwasmbench/sdk-wrapper-go-copyfile-time:latest -f Dockerfile.sdk-wrapper-go-copyfile .
	docker push us.icr.io/polyglotwasmbench/sdk-wrapper-go-copyfile-time:latest


sdk-wrapper-go-sort:
	docker build -t us.icr.io/polyglotwasmbench/sdk-wrapper-go-sort-time:latest -f Dockerfile.sdk-wrapper-go-sort .
	docker push us.icr.io/polyglotwasmbench/sdk-wrapper-go-sort-time:latest


sdk-wrapper-py-copyfile:
	docker build -t us.icr.io/polyglotwasmbench/sdk-wrapper-py-copyfile-time:latest -f Dockerfile.sdk-wrapper-py-copyfile .
	docker push us.icr.io/polyglotwasmbench/sdk-wrapper-py-copyfile-time:latest


sdk-wrapper-py-sort:
	docker build -t us.icr.io/polyglotwasmbench/sdk-wrapper-py-sort-time:latest -f Dockerfile.sdk-wrapper-py-sort .
	docker push us.icr.io/polyglotwasmbench/sdk-wrapper-py-sort-time:latest


sdk-wrapper-rust-copyfile:
	docker build -t us.icr.io/polyglotwasmbench/sdk-wrapper-rust-copyfile-time:latest -f Dockerfile.sdk-wrapper-rust-copyfile .
	docker push us.icr.io/polyglotwasmbench/sdk-wrapper-rust-copyfile-time:latest


sdk-wrapper-rust-sort:
	docker build -t us.icr.io/polyglotwasmbench/sdk-wrapper-rust-sort-time:latest -f Dockerfile.sdk-wrapper-rust-sort .
	docker push us.icr.io/polyglotwasmbench/sdk-wrapper-rust-sort-time:latest


sdk-wrapper-rust-httpserver:
	docker build -t us.icr.io/polyglotwasmbench/sdk-wrapper-rust-httpserver-time:latest -f Dockerfile.sdk-wrapper-rust-httpserver .
	docker push us.icr.io/polyglotwasmbench/sdk-wrapper-rust-httpserver-time:latest


sdk-wrapper-rust-echoserver:
	docker build -t us.icr.io/polyglotwasmbench/sdk-wrapper-rust-echoserver-time:latest -f Dockerfile.sdk-wrapper-rust-echoserver .
	docker push us.icr.io/polyglotwasmbench/sdk-wrapper-rust-echoserver-time:latest

