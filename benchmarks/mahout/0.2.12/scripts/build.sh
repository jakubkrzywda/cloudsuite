#!/bin/bash

BUILD_DIR=~/cloudsuite/benchmarks/mahout/0.2.12/

DIR=$(cd $(dirname $0) && pwd)
. $DIR/config

for node in $nodes; do
  ssh $user@$node "docker build --rm -t cloudsuite/mahout:latest $BUILD_DIR"
done

