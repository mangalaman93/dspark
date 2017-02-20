FROM mangalaman93/spark:2.1.0
MAINTAINER Aman Mangal <mangalaman93@gmail.com>

ADD docker-entrypoint.sh /

VOLUME /opt/spark/tmp
WORKDIR $SPARK_HOME
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["./bin/spark-class", "org.apache.spark.deploy.mesos.MesosExternalShuffleService"]
