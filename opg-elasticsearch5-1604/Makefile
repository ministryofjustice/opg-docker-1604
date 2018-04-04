.PHONY: build
SHELL = '/bin/bash'

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
image := $(current_dir)
registryUrl ?= registry.service.opg.digital
SEED := $(shell /bin/bash -c "echo $$RANDOM")

build:
	docker-compose -f tests/docker-compose.yml build

test:
	echo "Seed: ${SEED}"
	docker-compose -p "${SEED}" -f tests/docker-compose.yml up -d
	inspec exec tests -t docker://${SEED}_basegen_1
	docker-compose -p "${SEED}" -f tests/docker-compose.yml down

clean:
	docker-compose -p "${SEED}" -f tests/docker-compose.yml down
