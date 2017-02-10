FROM centos:7
MAINTAINER Aman Mangal <mangalaman93@gmail.com>

# explicitly set user/group IDs
RUN groupadd -r hadoop --gid=1000 && useradd -r -g hadoop -d /home/hadoop --uid=1000 hadoop

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.9
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64.asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && rm -r /root/.gnupg/ \
    && chmod +x /usr/local/bin/gosu

# Install Java
RUN yum -y --setopt=tsflags=nodocs install java-1.8.0-openjdk-devel && \
    yum clean all
ENV JAVA_HOME=/usr/lib/jvm/java

# We need mesosphere libs for running spark with mesos
RUN rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm && \
    yum -y install mesos && \
    yum clean all

# Download Spark
ENV SPARK_VERSION=2.1.0
ENV SPARK_DOWNLOAD_URL=http://www-eu.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz
RUN curl -o spark-$SPARK_VERSION-bin-hadoop2.7.tgz -SL $SPARK_DOWNLOAD_URL && \
    tar -xf spark-$SPARK_VERSION-bin-hadoop2.7.tgz && \
    mv spark-$SPARK_VERSION-bin-hadoop2.7 /opt/spark && \
    rm spark-$SPARK_VERSION-bin-hadoop2.7.tgz
ENV SPARK_HOME=/opt/spark
