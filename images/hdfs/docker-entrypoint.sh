#!/bin/bash
# SOURCE https://bitbucket.org/uhopper/hadoop-docker

# Set some sensible defaults
echo "setting up CORE_CONF_fs_defaultFS..."
export CORE_CONF_fs_defaultFS=${CORE_CONF_fs_defaultFS:-hdfs://`hostname -i`:9000}

function addProperty() {
    local path=$1
    local name=$2
    local value=$3
    local entry="<property><name>$name</name><value>${value}</value></property>"
    local escapedEntry=$(echo $entry | sed 's/\//\\\//g')
    sed -i "/<\/configuration>/ s/.*/${escapedEntry}\n&/" $path
}

function configure() {
    local path=$1
    local module=$2
    local envPrefix=$3
    local var
    local value
    echo "Configuring $module"
    for c in `printenv | perl -sne 'print "$1 " if m/^${envPrefix}_(.+?)=.*/' -- -envPrefix=$envPrefix`; do
        name=`echo ${c} | perl -pe 's/___/-/g; s/_/./g; s/\.\./_/g'`
        var="${envPrefix}_${c}"
        value=${!var}
        echo " - Setting $name=$value"
        addProperty ${HADOOP_CONF_DIR}/$module-site.xml $name "$value"
    done
}

if [[ $1 = 'hdfs' ]]; then
    configure ${HADOOP_CONF_DIR}/core-site.xml core CORE_CONF
    configure ${HADOOP_CONF_DIR}/hdfs-site.xml hdfs HDFS_CONF
    configure ${HADOOP_CONF_DIR}/yarn-site.xml yarn YARN_CONF
    configure ${HADOOP_CONF_DIR}/httpfs-site.xml httpfs HTTPFS_CONF
    configure ${HADOOP_CONF_DIR}/kms-site.xml kms KMS_CONF

    if [[ ! -z "$HDFS_CONF_dfs_namenode_name_dir" ]]; then
        if [ "`ls -A $HDFS_CONF_dfs_namenode_name_dir`" == "" ]; then
          echo "Formatting namenode name directory: $HDFS_CONF_dfs_namenode_name_dir"
          hdfs --config ${HADOOP_CONF_DIR} namenode -format ${CLUSTER_NAME}
        fi
    fi

    chown -R hadoop:hadoop ${HADOOP_CONF_DIR}
fi

if [[ ! -z ${HDFS_CONF_dfs_namenode_name_dir} ]]; then
    chown -R hadoop:hadoop ${HDFS_CONF_dfs_namenode_name_dir}
fi

if [[ ! -z ${HDFS_CONF_dfs_datanode_data_dir} ]]; then
    chown -R hadoop:hadoop ${HDFS_CONF_dfs_datanode_data_dir}
fi

exec gosu hadoop "$@"

