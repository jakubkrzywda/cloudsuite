#!/bin/bash

USAGE="Usage: $0 nslaves"

if [ $# -lt 1 ]; then
  echo "$USAGE"
  exit 1
fi

DIR=$(cd $(dirname $0) && pwd)
readarray nodes <$DIR/nodes

master_node=${nodes[0]}
ssh mihailov@$master_node "docker exec master benchmark 2>&1 | tee $DIR/log-$1"

