PROTOC_GEN_TS_PATH="./node_modules/.bin/protoc-gen-ts"
REGISTRY_DOMAIN=ghcr.io
REGISTRY_NAME=ghcr.io/wault-pw/eva
VERSION:=$(shell cat VERSION)

proto:
	protoc \
		--plugin="protoc-gen-ts=${PROTOC_GEN_TS_PATH}" \
		--js_out="import_style=commonjs,binary:desc" \
		--ts_out="desc" \
		--proto_path=protos \
		alice_v1.proto

test\:unit:
	yarn run test:unit

test\:e2e:
	yarn run test:e2e

generate\:mpa:
	rm -rf dist/*
	yarn run generate
	node ./scripts/integrity.js dist/index.html > dist/index0.html
	mv dist/index0.html dist/index.html

generate\:spa:
	node ./scripts/spa.js dist/index.html > dist/backup.html

generate\:licenses:
	yarn licenses list > dist/LICENSES.txt

tidy:
	npx -y yarn-deduplicate

build: export TAG=$(VERSION)
build:
	docker build --no-cache -f ./Dockerfile -t ${REGISTRY_NAME}:${TAG} --build-arg VERSION=${VERSION} .
	docker tag ${REGISTRY_NAME}:${TAG} ${REGISTRY_NAME}:latest

push: export TAG=$(VERSION)
push:
	docker push ${REGISTRY_NAME}:${TAG}
	docker push ${REGISTRY_NAME}:latest
