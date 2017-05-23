CORE_CONTAINERS:= opg-base-1604 opg-nginx-1604 opg-php-fpm-1604 opg-jre8-1604
ES_CONTAINERS:= opg-elasticsearch5-1604 opg-elasticsearch-shared-data-1604 opg-kibana-1604
CHILD_CONTAINERS:= opg-nginx-router-1604 #jenkins-slave0x644 jenkins20x644 rabbitmq0x644 wkhtmlpdf0x644 mongodb0x644

CLEAN_CONTAINERS := $(CORE_CONTAINERS) $(CHILD_CONTAINERS)

.PHONY: build push pull showinfo test $(CORE_CONTAINERS) $(CHILD_CONTAINERS) $(ES_CONTAINERS) clean

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
buildchild: $(CHILD_CONTAINERS)
buildes: $(ES_CONTAINERS)
build: buildcore buildchild buildes


$(CORE_CONTAINERS):
	$(MAKE) -C $@ newtag=$(newtag) registryUrl=$(registryUrl) no-cache=$(no-cache)

$(CHILD_CONTAINERS):
	$(MAKE) -C $@ newtag=$(newtag) registryUrl=$(registryUrl) no-cache=$(no-cache)

$(ES_CONTAINERS):
	$(MAKE) -C $@ newtag=$(newtag) registryUrl=$(registryUrl) no-cache=$(no-cache)

push:
	for i in $(CORE_CONTAINERS) $(CHILD_CONTAINERS) $(LTS_CONTAINERS); do \
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
	for i in $(CORE_CONTAINERS) $(CHILD_CONTAINERS) $(LTS_CONTAINERS); do \
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
	for i in $(CLEAN_CONTAINERS); do \
		docker rmi $(registryUrl)/$$i:$(currenttag) || true ; \
		docker rmi $(registryUrl)/$$i || true ; \
	done

all: showinfo build push clean
