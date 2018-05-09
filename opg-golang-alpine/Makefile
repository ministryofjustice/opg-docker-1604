.PHONY: build

registryUrl ?= registry.service.opg.digital
image = opg-golang-alpine

build:
	docker build --pull $(no-cache) -t "$(registryUrl)/$(image)" .
	# docker tag "$(registryUrl)/$(image)" "$(registryUrl)/$(image):$(newtag)"
