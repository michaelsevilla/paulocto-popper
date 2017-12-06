#!/bin/bash

echo "digraph G {" > tree.dot
ls -R $1 | while read p; do
  if [ ! -z $p ]; then
    if [[ "$p" == *: ]]; then
      PARENT=`basename $p | sed "s/\./\\n\./g"`
      PARENT=${PARENT::-1}
    else
      CHILD=`echo $p | sed "s/\./\\n\./g"`
      echo "  \"$PARENT\" -> \"$CHILD\";" >> tree.dot
    fi
  fi
done
echo "}" >> tree.dot

dot -Tpng -o tree.png tree.dot
