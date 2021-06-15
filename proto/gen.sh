dst=$(pwd)/source
rm -rf $dst
mkdir $dst

cd protobuf-d/
dub build :protoc-gen-d
dplugin=$(pwd)/build/protoc-gen-d
cd -

cd ../tensorflow/
protoc $PROTO_PATH --plugin=$dplugin --d_out=$dst tensorflow/core/protobuf/*.proto tensorflow/core/framework/*.proto
