// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: tensorflow/core/framework/tensor_description.proto

module tensorflow.tensor_description;

import google.protobuf;
import tensorflow.types;
import tensorflow.tensor_shape;
import tensorflow.allocation_description;

enum protocVersion = 3012004;

class TensorDescription
{
    @Proto(1) DataType dtype = protoDefaultValue!(DataType);
    @Proto(2) TensorShapeProto shape = protoDefaultValue!(TensorShapeProto);
    @Proto(4) AllocationDescription allocationDescription = protoDefaultValue!(AllocationDescription);
}
