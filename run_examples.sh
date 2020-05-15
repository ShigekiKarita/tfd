#!/usr/bin/env bash

echo "=== Running D examples ==="

for f in  \
  example/graph_import/graph_export.d \
  example/graph_import/graph_import.d
do
  echo "=> " $f
  (
    cd $(dirname $f)
    dub $(basename $f)
  )
done

echo "=== Running python examples ==="

for f in  \
  example/graph_import/graph_export.py \
  example/graph_import/graph_import.py
do
  echo "=> " $f
  (
    cd $(dirname $f)
    python $(basename $f)
  )
done
