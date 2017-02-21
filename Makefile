DOCKER = $(shell which docker)
	ifeq ($(DOCKER),)
$(error "docker not available on this system")
endif

REGISTRY_NAME=mangalaman93
IMAGES_DIR=images
HDFS_VERSION=2.7.3
SPARK_VERSION=2.1.0
DSPARK_VERSION=0.1.0

all: hdfs mesos shuffle spark executor dspark
.PHONY: all clean hdfs mesos shuffle spark executor dspark

hdfs:
	cd $(IMAGES_DIR)/$@ && $(DOCKER) build -t $(REGISTRY_NAME)/$@ .
	cd $(IMAGES_DIR)/$@ && $(DOCKER) tag $(REGISTRY_NAME)/$@:latest $(REGISTRY_NAME)/$@:$(HDFS_VERSION)

mesos:
	cd $(IMAGES_DIR)/$@ && $(DOCKER) build -t $(REGISTRY_NAME)/$@ .

spark:
	cd $(IMAGES_DIR)/$@ && $(DOCKER) build -t $(REGISTRY_NAME)/$@ .
	cd $(IMAGES_DIR)/$@ && $(DOCKER) tag $(REGISTRY_NAME)/$@:latest $(REGISTRY_NAME)/$@:$(SPARK_VERSION)

executor shuffle: spark
	cd $(IMAGES_DIR)/$@ && $(DOCKER) build -t $(REGISTRY_NAME)/$@ .
	cd $(IMAGES_DIR)/$@ && $(DOCKER) tag $(REGISTRY_NAME)/$@:latest $(REGISTRY_NAME)/$@:$(SPARK_VERSION)

dspark:
	cd $(IMAGES_DIR)/$@ && $(DOCKER) build -t $(REGISTRY_NAME)/$@ .
	cd $(IMAGES_DIR)/$@ && $(DOCKER) tag $(REGISTRY_NAME)/$@:latest $(REGISTRY_NAME)/$@:$(DSPARK_VERSION)

clean:
	./scripts/cleanup.sh
