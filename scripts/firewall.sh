#!/bin/bash

# Scripts to open ports on centos firewall
# Reference https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-firewalld-on-centos-7

set -e

# check whether script is run as root user
if [ "$EUID" -ne 0 ]; then
    echo "Error! Please run as root"
    exit 1
fi

function print_usage {
    echo "Usage: $0 subcommand [args]
    open <port>    opens the port on firewall
    list           lists all the open ports
    "
}

function get_default_zone {
    ZONE=$(firewall-cmd --get-default-zone)
}

function open_port {
    L_ZONE=$1
    L_PORT=$2
    echo "opening $L_PORT in zone $L_ZONE"
    firewall-cmd --zone=$L_ZONE --add-port=$L_PORT/tcp --permanent
    firewall-cmd --reload
}

# list
function list_open_ports {
    echo "Open Ports:"
    firewall-cmd --list-all | grep " ports: " | sed -e 's/\ \ ports\:\ //g' | tr ' ' '\n'
}

cmd=$1
if [[ $# -ge 1 ]]; then
    case $cmd in
        list)
            list_open_ports
            ;;
        open)
            shift
            get_default_zone
            DZONE=$ZONE
            for port in "$@"; do
                open_port $DZONE $port
            done
        ;;
        *)
            echo "Error! incorrect subcommand"
            print_usage
        ;;
    esac
else
    echo "Error! need a subcommand"
    print_usage
fi

