#!/bin/bash
set -e

# set permissions for spark/tmp directory
chown -R hadoop:hadoop /opt/spark/tmp

exec gosu hadoop "$@"
