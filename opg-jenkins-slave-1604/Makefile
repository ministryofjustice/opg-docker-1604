.PHONY: build

registryUrl ?= registry.service.opg.digital
image = opg-jenkins-slave-1604
SEED := $(shell /bin/bash -c "echo $$RANDOM")

build:
	docker build $(no-cache) -t "$(registryUrl)/$(image)" .
	docker tag "$(registryUrl)/$(image)" "$(registryUrl)/$(image):$(newtag)"

rebuild:
	docker-compose -f tests/docker-compose.yml -p test build

test:
	echo "Seed: ${SEED}"
	docker-compose -p "${SEED}" -f tests/docker-compose.yml up -d
	inspec exec tests -t docker://${SEED}_basegen_1
	docker-compose -p "${SEED}" -f tests/docker-compose.yml down
