DC := dmd

.PHONY: all clean

all: generated/tensorflow/c_api.d generated/tensorflow/op_def_pb.d generated/lib/libtensorflow_pb.a

# D bindings
generated/tensorflow/c_api.d: download/include/tensorflow/c/c_api.h
	bash ./dpp.sh tensorflow/c/c_api.h $@ tensorflow.c_api

generated/tensorflow/op_def_pb.d: generated/tensorflow/core/framework/op_def.pb-c.h
	bash ./dpp.sh tensorflow/core/framework/op_def.pb-c.h $@ tensorflow.op_def_pb


# Download deps
download/include/tensorflow/c/c_api.h:
	mkdir -p download
	cd download && wget https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-linux-x86_64-1.15.0.tar.gz
	cd download && tar xvf libtensorflow-cpu-linux-x86_64-1.15.0.tar.gz

# Generate protocol buffers
# Not only op_def.proto but also all tensorflow/core/framework/*.proto
generated/tensorflow/core/framework/op_def.pb-c.h: download/include/tensorflow/c/c_api.h
	mkdir -p generated
	cd tensorflow && protoc --c_out=../generated tensorflow/core/framework/*.proto

generated/lib/libtensorflow_pb.a: generated/tensorflow/core/framework/op_def.pb-c.h
	mkdir -p generated/lib
	cd generated/lib && gcc -c ../tensorflow/core/framework/*.c -I.. && ar rcs libtensorflow_pb.a *.o && rm *.o


clean:
	dub clean
	rm -rfv generated

test: all
	LIBRARY_PATH=`pwd`/download/lib dub test --parallel --compiler=$(DC)
