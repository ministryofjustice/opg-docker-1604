.PHONY: build

registryUrl ?= registry.service.opg.digital
image = opg-backupninja-1604

build:
	docker build --pull $(no-cache) -t "$(registryUrl)/$(image)" .
	docker tag "$(registryUrl)/$(image)" "$(registryUrl)/$(image):$(newtag)"
