.PHONY: build

registryUrl ?= registry.service.opg.digital
image = opg-elasticsearch5-1604

build:
	docker build -t "$(registryUrl)/$(image)" .
	docker tag  "$(registryUrl)/$(image)" "$(registryUrl)/$(image):$(newtag)"

rebuild:
	docker-compose -f tests/docker-compose.yml -p test build

test:
	rand=$$(date +'%H%M%S') &&\
	docker-compose -p "$${rand}" -f tests/docker-compose.yml up -d &&\
	inspec exec tests -t "docker://$${rand}_basegen_1" &&\
	docker-compose -p "$${rand}" -f tests/docker-compose.yml down
