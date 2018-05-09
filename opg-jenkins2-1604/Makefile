.PHONY: build

registryUrl ?= registry.service.opg.digital

image = opg-jenkins2-1604

build:
	docker build $(no-cache) -t "$(registryUrl)/$(image)" .
	# docker tag "$(registryUrl)/$(image)" "$(registryUrl)/$(image):$(newtag)"
