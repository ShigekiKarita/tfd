# tfd: tensorflow for D

![CI](https://github.com/ShigekiKarita/tfd/workflows/CI/badge.svg)
[![codecov](https://codecov.io/gh/ShigekiKarita/tfd/branch/master/graph/badge.svg)](https://codecov.io/gh/ShigekiKarita/tfd)
[![Dub version](https://img.shields.io/dub/v/tfd.svg)](https://code.dlang.org/packages/tfd)

## Roadmap

- [x] Setup CI
- [x] Wrap tensor and session for basic usages (see `tfd.session` unittests).
- [ ] Use [pbd](https://github.com/ShigekiKarita/pbd) to save/load proto files.
- [ ] Example using C API to save/load TF graphs.
- [ ] Parse `ops.pbtxt` to generate typed ops bindings.
- [ ] Rewrite C API example with typed bindings.
- [ ] Implement autograd, and simple training APIs in D.

## Requirements

- [libtensorflow](https://www.tensorflow.org/install/lang_c). Currently, tfd only supports
  - [Linux v1.15.0](https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-linux-x86_64-1.15.0.tar.gz)
  - [Windows v1.15.0](https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-windows-x86_64-1.15.0.zip)

## Re-generate bindings

tfd uses [dpp](https://github.com/atilaneves/dpp) to generate bindings from TF C-API. You need `libclang` to run dpp.

```bash
dub fetch dpp
dub run dpp -- --preprocess-only --include-path ./download/include <target dpp file>
```
