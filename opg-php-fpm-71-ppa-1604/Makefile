.PHONY: build

registryUrl ?= registry.service.opg.digital

image = opg-php71-fpm-1604

build:
	docker build $(no-cache) -t "$(registryUrl)/$(image)" .
	docker tag  "$(registryUrl)/$(image)" "$(registryUrl)/$(image):$(newtag)"
