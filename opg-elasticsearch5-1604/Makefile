.PHONY: build

registryUrl ?= registry.service.opg.digital
image = opg-elasticsearch5-1604

build:
	docker build -t "$(registryUrl)/$(image)" .
	docker tag  "$(registryUrl)/$(image)" "$(registryUrl)/$(image):$(newtag)"

test:
	docker-compose -f tests/docker-compose.yml -p test up -d basegen
	inspec exec tests -t docker://test_basegen_1
	docker-compose -f tests/docker-compose.yml -p test down

rebuild:
	docker-compose -f tests/docker-compose.yml -p test build
