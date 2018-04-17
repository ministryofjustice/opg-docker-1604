.PHONY: build

registryUrl ?= registry.service.opg.digital

image = opg-php-fpm-71-ppa-1604

build:
	docker build $(no-cache) -t "$(registryUrl)/$(image)" .
	docker tag  "$(registryUrl)/$(image)" "$(registryUrl)/$(image):$(newtag)"
