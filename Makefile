PROTOC_VERSION := 1.3.3

.PHONY: all clean

all: generated/tensorflow/c_api.d generated/tensorflow/op_def_pb.d generated/lib/libtensorflow_pb.a

# Generate D bindings
generated/tensorflow/c_api.d: download/include/tensorflow/c/c_api.h
	bash ./dpp.sh tensorflow/c/c_api.h $@ tensorflow.c_api

generated/tensorflow/op_def_pb.d: generated/tensorflow/core/framework/op_def.pb-c.h
	bash ./dpp.sh tensorflow/core/framework/op_def.pb-c.h $@ tensorflow.op_def_pb


# Download deps
download/include/tensorflow/c/c_api.h:
	mkdir -p download
	cd download && wget https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-linux-x86_64-1.15.0.tar.gz
	cd download && tar xvf libtensorflow-cpu-linux-x86_64-1.15.0.tar.gz

download/bin/protoc-c:
	mkdir -p download
	cd download && wget https://github.com/protobuf-c/protobuf-c/releases/download/v$(PROTOC_VERSION)/protobuf-c-$(PROTOC_VERSION).tar.gz
	cd download && tar xvf protobuf-c-$(PROTOC_VERSION).tar.gz
	cd download/protobuf-c-$(PROTOC_VERSION) && ./configure --prefix=$(PWD)/download && make -j4 && make install


# Generate ProtocolBuffer in C
generated/tensorflow/core/framework/op_def.pb-c.h: download/include/tensorflow/c/c_api.h download/bin/protoc-c
	mkdir -p generated
	cd tensorflow && ../download/bin/protoc-c --c_out=../generated tensorflow/core/framework/*.proto

generated/lib/libtensorflow_pb.a: generated/tensorflow/core/framework/op_def.pb-c.h
	mkdir -p generated/lib
	cd generated/lib && gcc -c ../tensorflow/core/framework/*.c -I.. -I../../download/include && ar rcs libtensorflow_pb.a *.o && rm *.o


clean:
	dub clean
	rm -rfv generated

test: all
	LIBRARY_PATH=`pwd`/download/lib dub test --parallel

