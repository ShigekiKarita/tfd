// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: tensorflow/core/framework/resource_handle.proto

module tensorflow.resource_handle;

import google.protobuf;
import tensorflow.tensor_shape;
import tensorflow.types;

enum protocVersion = 3012004;

class ResourceHandleProto
{
    @Proto(1) string device = protoDefaultValue!(string);
    @Proto(2) string container = protoDefaultValue!(string);
    @Proto(3) string name = protoDefaultValue!(string);
    @Proto(4) ulong hashCode = protoDefaultValue!(ulong);
    @Proto(5) string maybeTypeName = protoDefaultValue!(string);
    @Proto(6) ResourceHandleProto.DtypeAndShape[] dtypesAndShapes = protoDefaultValue!(ResourceHandleProto.DtypeAndShape[]);

    static class DtypeAndShape
    {
        @Proto(1) DataType dtype = protoDefaultValue!(DataType);
        @Proto(2) TensorShapeProto shape = protoDefaultValue!(TensorShapeProto);
    }
}