// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: tensorflow/core/framework/tensor.proto

module tensorflow.tensor;

import google.protobuf;
import tensorflow.resource_handle;
import tensorflow.tensor_shape;
import tensorflow.types;

enum protocVersion = 3012004;

class TensorProto
{
    @Proto(1) DataType dtype = protoDefaultValue!(DataType);
    @Proto(2) TensorShapeProto tensorShape = protoDefaultValue!(TensorShapeProto);
    @Proto(3) int versionNumber = protoDefaultValue!(int);
    @Proto(4) bytes tensorContent = protoDefaultValue!(bytes);
    @Proto(5, Wire.none, Yes.packed) float[] floatVal = protoDefaultValue!(float[]);
    @Proto(6, Wire.none, Yes.packed) double[] doubleVal = protoDefaultValue!(double[]);
    @Proto(7, Wire.none, Yes.packed) int[] intVal = protoDefaultValue!(int[]);
    @Proto(8) bytes[] stringVal = protoDefaultValue!(bytes[]);
    @Proto(9, Wire.none, Yes.packed) float[] scomplexVal = protoDefaultValue!(float[]);
    @Proto(10, Wire.none, Yes.packed) long[] int64Val = protoDefaultValue!(long[]);
    @Proto(11, Wire.none, Yes.packed) bool[] boolVal = protoDefaultValue!(bool[]);
    @Proto(12, Wire.none, Yes.packed) double[] dcomplexVal = protoDefaultValue!(double[]);
    @Proto(13, Wire.none, Yes.packed) int[] halfVal = protoDefaultValue!(int[]);
    @Proto(14) ResourceHandleProto[] resourceHandleVal = protoDefaultValue!(ResourceHandleProto[]);
    @Proto(15) VariantTensorDataProto[] variantVal = protoDefaultValue!(VariantTensorDataProto[]);
    @Proto(16, Wire.none, Yes.packed) uint[] uint32Val = protoDefaultValue!(uint[]);
    @Proto(17, Wire.none, Yes.packed) ulong[] uint64Val = protoDefaultValue!(ulong[]);
}

class VariantTensorDataProto
{
    @Proto(1) string typeName = protoDefaultValue!(string);
    @Proto(2) bytes metadata = protoDefaultValue!(bytes);
    @Proto(3) TensorProto[] tensors = protoDefaultValue!(TensorProto[]);
}