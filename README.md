# tfd: tensorflow for D

## TODO

- Setup CI
- Example using C API to save/load TF graphs.
- Parse `ops.pbtxt` and generate typed bindings.
- Rewrite C API example with typed bindings.
- Implement autograd in D.

## Requirements

- [libtensorflow_framework.so (v.1.15)](https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-linux-x86_64-1.15.0.tar.gz)
- [protobuf-c](https://github.com/protobuf-c/protobuf-c)

## Re-generate bindings

Some stable API bindings (`c_api.h`, `op_def.proto`, etc) are stored under `generated`. If you wanna regenerate them for your environment, try:
```bash
make clean
make
```
