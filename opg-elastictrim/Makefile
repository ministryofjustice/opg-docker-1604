.PHONY: build

registryUrl ?= registry.service.opg.digital
image = opg-elastictrim

build:
	docker build -t "$(registryUrl)/$(image)" .
	# docker tag  "$(registryUrl)/$(image)" "$(registryUrl)/$(image):$(newtag)"
