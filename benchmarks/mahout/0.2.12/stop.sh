#!/bin/bash

DIR=$(cd $(dirname $0) && pwd)
readarray nodes <$DIR/nodes

for node in "${nodes[@]}"; do
  ssh mihailov@$node 'docker ps -q --filter ancestor=cloudsuite/mahout | xargs docker stop | xargs docker rm'
done

