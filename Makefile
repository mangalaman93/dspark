DOCKER = $(shell which docker)
	ifeq ($(DOCKER),)
$(error "docker not available on this system")
endif

REGISTRY_NAME=mangalaman93
IMAGES_DIR=images

all: hdfs mesos shuffle spark executor
.PHONY: all clean hdfs mesos shuffle spark executor

hdfs mesos spark:
	cd $(IMAGES_DIR)/$@ && $(DOCKER) build -t $(REGISTRY_NAME)/$@ .

executor shuffle: spark
	cd $(IMAGES_DIR)/$@ && $(DOCKER) build -t $(REGISTRY_NAME)/$@ .

clean:
	./scripts/cleanup.sh
