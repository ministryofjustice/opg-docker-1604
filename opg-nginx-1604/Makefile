.PHONY: build test

registryUrl ?= registry.service.opg.digital

image = opg-nginx-1604

build:
	docker build $(no-cache) -t "$(registryUrl)/$(image)" .
	docker tag "$(registryUrl)/$(image)" "$(registryUrl)/$(image):$(newtag)"
