# dspark
Run spark in docker containers. For more details, checkout [wiki](https://github.com/mangalaman93/dspark/wiki)

# Run spark shell
```
docker run --net=compose_default --rm -it -p 4040:4040 --name=spark-shell mangalaman93/spark-shell:2.1.0 --master mesos://zk://$HOST_IP:2181,$HOST_IP:2182,$HOST_IP:2183/mesos --conf spark.mesos.executor.docker.image=mangalaman93/executor:2.1.0 --conf spark.mesos.executor.home=/opt/spark --conf spark.ui.port=4040
val textFile = sc.textFile("/opt/spark/README.md")
textFile.map(line => line.split(" ").size).reduce((a, b) => if (a > b) a else b)
```

# Run `dspark` example
## Run `dspark`
```
docker run --net=compose_default --rm -it -p 4040:4040 -p 4042:4042 --name=dspark -e DSPARK_PORT=4042 -e DSPARK_LISTENING_IP=0.0.0.0 -e SPARK_MASTER=mesos://zk://$HOST_IP:2181,$HOST_IP:2182,$HOST_IP:2183/mesos -e spark_mesos_executor_docker_image=mangalaman93/executor:2.1.0 -e spark_mesos_executor_home=/opt/spark -e spark_local_dir=/opt/spark/tmp -e spark_ui_port=4040 -e spark_mesos_executor_docker_volumes=/opt/run/tmp:/opt/spark/tmp -e spark_jars=/opt/dspark/dspark.jar mangalaman93/dspark:0.1.0
```

## Add a file to HDFS
```
docker run --rm -it -e HOST_IP=$HOST_IP  --net=compose_default mangalaman93/hdfs bash
hdfs dfs -fs=hdfs://$HOST_IP:9000 -put /anaconda-post.log /inputfile
```

## Send request to run a job
```
curl -X POST -G http://$HOST_IP:4042/job --data-urlencode "input=hdfs://$HOST_IP:9000/inputfile" --data-urlencode "output=hdfs://$HOST_IP:9000/outputfile"
```

## Check results
```
docker run --rm -it -e HOST_IP=$HOST_IP --net=compose_default mangalaman93/hdfs bash
hdfs dfs -fs=hdfs://$HOST_IP:9000 -ls /outputfile
hdfs dfs -fs=hdfs://$HOST_IP:9000 -cat /outputfile/part-00000
```

# Todo
* Avoid running `shuffle` service in the host network mode
* Avoid running `namenode` and `datanode` services in the host network mode
* Setup an HA cluster of HDFS with at least 3 datanodes
* Spark-submit etc.
* Multinode setup

# Issues/Enhancements
* Hostname look up issue with mesos
* Fix spark tmp directory as volume only when necessary
* Use different private and public IPs (not just `HOST_IP`)
