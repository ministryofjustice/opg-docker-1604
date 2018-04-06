.PHONY: build

registryUrl = registry.service.opg.digital
image = opg-ssmtp-1604
docker_dir = .
SEED := $(shell /bin/bash -c "echo $$RANDOM")

build:
	cd ${docker_dir} && docker build -t "$(registryUrl)/$(image)" .
	cd ${docker_dir} && docker tag "$(registryUrl)/$(image)" "$(registryUrl)/$(image):$(newtag)"

rebuild:
	docker-compose -f tests/docker-compose.yml -p test build

test:
	echo "Seed: ${SEED}"
	docker-compose -p "${SEED}" -f tests/docker-compose.yml up -d
	inspec exec tests -t docker://${SEED}_basegen_1
	docker-compose -p "${SEED}" -f tests/docker-compose.yml down
