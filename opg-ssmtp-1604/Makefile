.PHONY: build

registryUrl = registry.service.opg.digital
image = opg-ssmtp-1604
docker_dir = .

build:
	cd ${docker_dir} && docker build -t "$(registryUrl)/$(image)" .
	cd ${docker_dir} && docker tag "$(registryUrl)/$(image)" "$(registryUrl)/$(image):$(newtag)"
