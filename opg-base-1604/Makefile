.PHONY: build

registryUrl ?= registry.service.opg.digital

image = opg-base-1604

build:
	docker build $(no-cache) -t "$(registryUrl)/$(image)" .
	docker tag "$(registryUrl)/$(image)" "$(registryUrl)/$(image):$(newtag)"

rebuild:
	docker-compose -p test build

test:
	docker-compose -p test up -d basegen
	inspec exec tests -t docker://test_basegen_1
	docker-compose -p test down
