#!/bin/bash

USAGE="Usage: $0 nslaves [host]"

if [ $# -lt 1 ]; then
  echo "$USAGE"
  exit 1
fi

DIR=$(cd $(dirname $0) && pwd)
readarray nodes <$DIR/nodes

nodes_index=0
node=${nodes[0]}

function next_node() {
  nodes_index=$(( ($nodes_index + 1) % ${#nodes[@]} ))
  node=${nodes[$nodes_index]}
}

case $2 in
  host)
    master_node=${nodes[0]}
    ssh mihailov@$master_node 'docker run -d --net host --name master cloudsuite/mahout master'
    for (( i=1; i<=$1; i+=1 )); do
      ssh mihailov@$node "docker run -d --net host --name slave$i cloudsuite/mahout slave $master_node"
      next_node
    done
    ;;
  *)
    master_node=${nodes[0]}
    ssh mihailov@$master_node 'docker run -d --net hadoop-net --name master --hostname master cloudsuite/mahout master'
    for (( i=1; i<=$1; i+=1 )); do
      ssh mihailov@$node "docker run -d --net hadoop-net --name slave$i --hostname slave$i cloudsuite/mahout slave"
      next_node
    done
    ;;
esac

