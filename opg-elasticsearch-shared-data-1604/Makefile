.PHONY: build

registryUrl ?= registry.service.opg.digital
image = opg-elasticsearch-shared-data-1604

build:
	docker build $(no-cache) -t "$(registryUrl)/$(image)" .
	docker tag "$(registryUrl)/$(image)" "$(registryUrl)/$(image):$(newtag)"
