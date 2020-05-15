#!/usr/bin/env bash

echo "=== Running examples ==="
(

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
)
