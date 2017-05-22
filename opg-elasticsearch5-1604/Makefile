.PHONY: build

registryUrl ?= registry.service.opg.digital
image = opg-elasticsearch5-1604

build:
	docker build -t "$(registryUrl)/$(image)" .
	docker tag  "$(registryUrl)/$(image)" "$(registryUrl)/$(image):$(newtag)"
