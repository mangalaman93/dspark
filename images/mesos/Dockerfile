FROM centos:7
MAINTAINER Aman Mangal <mangalaman93@gmail.com>

ENV MESOS_SYSTEMD_ENABLE_SUPPORT=false

RUN yum -y --setopt=tsflags=nodocs install java-1.8.0-openjdk libtool-ltdl && \
    yum clean all
ENV JAVA_HOME=/usr/lib/jvm/java

RUN rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm && \
    yum -y install mesos && \
    yum clean all
