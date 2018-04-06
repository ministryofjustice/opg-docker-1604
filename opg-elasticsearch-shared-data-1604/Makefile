.PHONY: build

registryUrl ?= registry.service.opg.digital
image = opg-elasticsearch-shared-data-1604
SEED := $(shell /bin/bash -c "echo $$RANDOM")

build:
	docker build $(no-cache) -t "$(registryUrl)/$(image)" .
	docker tag "$(registryUrl)/$(image)" "$(registryUrl)/$(image):$(newtag)"

rebuild:
	docker-compose -f tests/docker-compose.yml -p test build

test:
	rand=$RANDOM &&\
	docker-compose -p "$${rand}" -f tests/docker-compose.yml up -d &&\
	inspec exec tests -t "docker://$${rand}_basegen_1" &&\
	docker-compose -p "$${rand}" -f tests/docker-compose.yml down
