# cd protobuf-d && dub build :protoc-gen-d && cd -

mkdir -p generated/tensorflow/core/framework

cd tensorflow && protoc $$PROTO_PATH --plugin=../protobuf-d/build/protoc-gen-d --d_opt=message-as-struct --d_out=../source/tensorflow/core/framework/ tensorflow/core/framework/op_def.proto && cd -
