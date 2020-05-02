#!bash

set -euo

# e.g., tensorflow/c/c_api.h
cfile=$1
# e.g., generated/tensorflow/c_api.d
dfile=$2
# e.g., tensorflow.c_api
dmodule=$3
mkdir -p $(dirname $dfile)
echo "module ${dmodule};
#include <${cfile}>" > ${dfile}pp

# dub fetch dpp
dub run dpp -- --preprocess-only --include-path ./download/include --include-path tensorflow/ ${dfile}pp
