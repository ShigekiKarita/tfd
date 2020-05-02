.PHONY: all clean

all: generated/tensorflow/c_api.d generated/tensorflow/c_api_experimental.d generated/tensorflow/op_def_pb.d generated/lib/libtensorflow_pb.a

protobuf-d/build/protoc-gen-d:
	cd protobuf-d && dub build :protoc-gen-d

# Not only op_def.proto but also all tensorflow/core/framework/*.proto
generated/tensorflow/op_def.d: protobuf-d/build/protoc-gen-d
	mkdir -p generated/tensorflow
	cd tensorflow && protoc --plugin=../protobuf-d/build/protoc-gen-d --d_out=../generated tensorflow/core/framework/op_def.proto
	sed -i 's/^module tensorflow/module tensorflow.core.framework/' ./generated/tensorflow/*.d

generated/tensorflow/c_api.d: download/include/tensorflow/c/c_api.h
	bash ./dpp.sh tensorflow/c/c_api.h $@ tensorflow.c_api

generated/tensorflow/c_api_experimental.d: download/include/tensorflow/c/c_api.h
	bash ./dpp.sh tensorflow/c/c_api_experimental.h $@ tensorflow.c_api_experimental

generated/tensorflow/env.d: download/include/tensorflow/c/c_api.h
	bash ./dpp.sh tensorflow/c/env.h $@ tensorflow.env

generated/tensorflow/kernels.d: download/include/tensorflow/c/c_api.h
	bash ./dpp.sh tensorflow/c/kernels.h $@ tensorflow.kernels


download/libtensorflow-cpu-linux-x86_64-1.15.0.tar.gz:
	mkdir download
	cd download && wget https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-linux-x86_64-1.15.0.tar.gz

download/include/tensorflow/c/c_api.h:
	cd download && tar xvf libtensorflow-cpu-linux-x86_64-1.15.0.tar.gz

# Not only op_def.proto but also all tensorflow/core/framework/*.proto
generated/tensorflow/core/framework/op_def.pb-c.h: download/include/tensorflow/c/c_api.h
	mkdir -p generated
	cd tensorflow && protoc --c_out=../generated tensorflow/core/framework/*.proto

generated/tensorflow/op_def_pb.d: generated/tensorflow/core/framework/op_def.pb-c.h
	mkdir -p generated/tensorflow
	echo "module tensorflow.op_def_pb;\n#include <tensorflow/core/framework/op_def.pb-c.h>" > generated/tensorflow/op_def_pb.dpp
	dub fetch dpp
	dub run dpp -- --preprocess-only --include-path ./generated generated/tensorflow/op_def_pb.dpp

generated/lib/libtensorflow_pb.a: generated/tensorflow/core/framework/op_def.pb-c.h
	mkdir -p generated/lib
	cd generated/lib && gcc -c ../tensorflow/core/framework/*.c -I.. && ar rcs libtensorflow_pb.a *.o && rm *.o


clean:
	dub clean
	rm -rfv generated

test: all
	dub test
