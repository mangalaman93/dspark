#!/bin/bash

# Add ./bin/spark-class as command if needed
if [ "${1:0:1}" = '-' ]; then
    set -- ./bin/spark-class "$@"
fi

if [ "$1" = './bin/spark-class' ]; then
	# set mesos master
    if [ -z "$MESOS_MASTER" ]; then
        echo "error: MESOS_MASTER must be defined"
        exit 1
    fi

    # set shuffle service port
    if [ -z "$SPARK_SHUFFLE_SERVICE_PORT" ]; then
        echo "setting SPARK_SHUFFLE_SERVICE_PORT=7337"
        SPARK_SHUFFLE_SERVICE_PORT=7337
    fi

    export SPARK_SHUFFLE_OPTS="-Dspark.shuffle.service.enabled=true
                               -Dspark.shuffle.service.port=$SPARK_SHUFFLE_SERVICE_PORT"

    # set permissions
    chown -R hadoop:hadoop /opt/spark/tmp

    # set command
    set -- "$@" --master $MESOS_MASTER
fi

exec gosu hadoop "$@"

