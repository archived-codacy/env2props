CRYSTAL=/usr/bin/crystal
CRYSTAL_FLAGS=--release

all: fmt build

.PHONY: fmt
fmt: ## format the crystal sources
	$(CRYSTAL) tool format

.PHONY: docker
build: fmt ## compiles from crystal sources
	mkdir -p bin
	$(CRYSTAL) build $(CRYSTAL_FLAGS) src/env2props.cr -o bin/env2props

.PHONY: test
test: build ## runs crystal tests
	wget -nc http://central.maven.org/maven2/com/typesafe/config/1.3.2/config-1.3.2.jar
	javac spec/CheckProperties.java
	javac -cp config-1.3.2.jar spec/CheckTypesafeConfig.java
	$(CRYSTAL) spec spec/*.cr

.PHONY: clean
clean: ## clean target directories
	rm -rf bin

buildStatic: ## compiles from crystal sources into static binary
	mkdir -p bin
	docker run --rm -it -v $(PWD):/app -w /app durosoft/crystal-alpine:latest crystal build src/env2props.cr -o bin/env2props --release --static --no-debug

.PHONY: help
help:
	@echo "make help"
	@echo "\n"
	@grep -E '^[a-zA-Z_/%\-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo "\n"
