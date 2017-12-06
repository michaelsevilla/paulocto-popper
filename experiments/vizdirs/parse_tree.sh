#!/bin/bash

echo "digraph G {"
ls -R $1 | while read p; do
  if [ ! -z $p ]; then
    if [[ "$p" == *: ]]; then
      PARENT=`basename $p`
      PARENT=${PARENT::-1}
    else
      echo "  $PARENT -> $p;"
    fi
  fi
done
echo "}"
