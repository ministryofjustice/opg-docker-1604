CORE_CONTAINERS:= opg-base-1604 opg-nginx-1604 opg-php-fpm-1604 opg-jre8-1604 opg-golang-1604
ES_CONTAINERS:= opg-elasticsearch5-1604 opg-elasticsearch-shared-data-1604 opg-kibana-1604
WEB_CONTAINERS:= opg-nginx-router-1604 opg-wkhtmlpdf-1604 opg-ssmtp-1604
DATA_CONTAINERS:= opg-rabbitmq-1604 opg-mongodb-1604
JENKINS_CONTAINERS:= opg-jenkins2-1604 opg-jenkins-slave-1604
DEV_CONTAINERS:= opg-phpunit-1604 opg-phpcs-1604

ALL_CONTAINERS := $(CORE_CONTAINERS) $(ES_CONTAINERS) $(DATA_CONTAINERS) $(JENKINS_CONTAINERS) $(WEB_CONTAINERS) $(DEV_CONTAINERS)

.PHONY: build push pull showinfo $(CORE_CONTAINERS) $(ES_CONTAINERS) $(DATA_CONTAINERS) $(JENKINS_CONTAINERS) $(WEB_CONTAINERS) $(DEV_CONTAINERS) clean

tagrepo = no
ifneq ($(stage),)
	stagearg = --stage $(stage)
endif

ifdef buildArgs
	no-cache := --no-cache
endif

currenttag = $(shell semvertag latest $(stagearg))
ifneq ($(findstring ERROR, $(currenttag)),)
	currenttag = 0.0.0
	ifneq ($(stage),)
		currenttag = 0.0.0-$(stage)
	endif
endif

newtag = $(shell semvertag bump patch $(stagearg))
ifneq ($(findstring ERROR, $(newtag)),)
	newtag = 0.0.1
	ifneq ($(stage),)
		newtag = 0.0.1-$(stage)
	endif
endif

registryUrl = registry.service.opg.digital

buildcore: $(CORE_CONTAINERS)
builddata: $(DATA_CONTAINERS)
buildes: $(ES_CONTAINERS)
buildjenkins: $(JENKINS_CONTAINERS)
buildweb: $(WEB_CONTAINERS)
builddev: $(DEV_CONTAINERS)
build: buildcore builddata buildes buildjenkins buildweb builddev


$(CORE_CONTAINERS):
	$(MAKE) -C $@ newtag=$(newtag) registryUrl=$(registryUrl) no-cache=$(no-cache)

$(DATA_CONTAINERS):
	$(MAKE) -C $@ newtag=$(newtag) registryUrl=$(registryUrl) no-cache=$(no-cache)

$(ES_CONTAINERS):
	$(MAKE) -C $@ newtag=$(newtag) registryUrl=$(registryUrl) no-cache=$(no-cache)

$(JENKINS_CONTAINERS):
	$(MAKE) -C $@ newtag=$(newtag) registryUrl=$(registryUrl) no-cache=$(no-cache)

$(WEB_CONTAINERS):
	$(MAKE) -C $@ newtag=$(newtag) registryUrl=$(registryUrl) no-cache=$(no-cache)

$(DEV_CONTAINERS):
	$(MAKE) -C $@ newtag=$(newtag) registryUrl=$(registryUrl) no-cache=$(no-cache)

push:
	for i in $(ALL_CONTAINERS); do \
			[ "$(stagearg)x" = "x" ] && docker push $(registryUrl)/$$i ; \
			docker push $(registryUrl)/$$i:$(newtag) ; \
	done
ifeq ($(tagrepo),yes)
	@echo -e Tagging repo
	semvertag tag $(newtag)
else
	@echo -e Not tagging repo
endif

pull:
	for i in $(ALL_CONTAINERS); do \
			docker pull $(registryUrl)/$$i ; \
	done

showinfo:
	@echo Registry: $(registryUrl)
	@echo Newtag: $(newtag)
	@echo Stage: $(stagearg)
	@echo Current Tag: $(currenttag)
	@echo Core Container List: $(CORE_CONTAINERS)
	@echo Container List: $(CHILD_CONTAINERS)
	@echo Clean Container List: $(CLEAN_CONTAINERS)
ifeq ($(tagrepo),yes)
	@echo Tagging repo: $(tagrepo)
endif

clean:
	for i in $(ALL_CONTAINERS); do \
		docker rmi $(registryUrl)/$$i:$(currenttag) || true ; \
		docker rmi $(registryUrl)/$$i || true ; \
	done

all: showinfo build push clean
