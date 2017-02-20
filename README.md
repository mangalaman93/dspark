# dspark
Run spark in docker containers. For more details, checkout [wiki](https://github.com/mangalaman93/dspark/wiki)

# Run spark shell
```
docker run --net=compose_default --rm -it mangalaman93/executor:2.1.0 /opt/spark/bin/spark-shell --master mesos://zk://$HOST_IP:2181,$HOST_IP:2182,$HOST_IP:2183/mesos --conf spark.mesos.executor.docker.image=mangalaman93/executor --conf spark.mesos.executor.home=/opt/spark
val textFile = sc.textFile("/opt/spark/README.md")
textFile.map(line => line.split(" ").size).reduce((a, b) => if (a > b) a else b)
```

# Todo
* Avoid running `shuffle` service in the host network mode
* Avoid running `namenode` and `datanode` services in the host network mode
* Setup an HA cluster of HDFS with at least 3 datanodes
