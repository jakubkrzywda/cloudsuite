#!/bin/bash

BUILD_DIR=~/cloudsuite/benchmarks/mahout/0.2.12/

DIR=$(cd $(dirname $0) && pwd)
readarray nodes <$DIR/nodes

for node in "${nodes[@]}"; do
  ssh mihailov@$node "docker build --rm -t cloudsuite/mahout:latest $BUILD_DIR"
done

