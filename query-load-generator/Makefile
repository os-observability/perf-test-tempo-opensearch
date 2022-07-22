
IMG ?= ghcr.io/pavolloffay/perf-test-tempo-opensearch/query-load-generator
VERSION ?= 2

image-build:
	docker build -f Dockerfile -t ${IMG}:${VERSION} .

image-push:
	docker push ${IMG}:${VERSION}

run:
	NAMESPACE=opensearch QUERY_FILE=queries.txt QUERY_LOOKBACK=2h JAEGER_QUERY_ENDPOINT=http://localhost:16686 QUERY_DELAY=10s go run main.go
