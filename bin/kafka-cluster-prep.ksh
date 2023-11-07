#!/usr/bin/env bash

### Set up basic path and permissions to assist the script
umask 022
export PATH="/usr/bin:/usr/local/bin:/sbin:/usr/sbin:$PATH"

### Define the bin and the etc directory as related to the running script
BINDIR=$(dirname "$(realpath "$0")")
ETCDIR=$( realpath "$BINDIR"/../etc )

KAFKA_BASE_DIR="/usr/local/kafka"
mkdir -p "${KAFKA_BASE_DIR}"

KAFKA_ETC_DIR="/etc/kafka"
mkdir -p "${KAFKA_ETC_DIR}"

KAFKA_SVC_DIR="/etc/systemd/system"
mkdir -p "${KAFKA_SVC_DIR}"

KAFKA_DATA_DIR="/var/local/data/kafka"
ZOOKEEPER_DATA_DIR="/var/local/data/zookeeper"
mkdir -p "${KAFKA_DATA_DIR}" "${ZOOKEEPER_DATA_DIR}"

KAFKA_LOGS_DIR="/var/log/kafka"
ZOOKEEPER_LOGS_DIR="/var/log/zookeeper"
mkdir -p "${KAFKA_LOGS_DIR}" "${ZOOKEEPER_LOGS_DIR}"

### Install the cluster configuration
ZOOKEEPERID=$( host $( hostname ) | grep -E -v 'IPv6' | awk '{print$4}' | cut -d '.' -f 4 )
echo "$ZOOKEEPERID" > "$ZOOKEEPER_DATA_DIR/myid"

### Now start the kafka service
systemctl start kafka
systemctl enable kafka
systemctl status kafka | grep -E -i 'Active|PID'

### Now start the zookeeper service
systemctl start zookeeper
systemctl enable zookeeper
systemctl status zookeeper | grep -E -i 'Active|PID'
