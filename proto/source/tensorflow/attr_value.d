// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: tensorflow/core/framework/attr_value.proto

module tensorflow.attr_value;

import google.protobuf;
import tensorflow.tensor;
import tensorflow.tensor_shape;
import tensorflow.types;

enum protocVersion = 3012004;

class AttrValue
{
    enum ValueCase
    {
        valueNotSet = 0,
        list = 1,
        s = 2,
        i = 3,
        f = 4,
        b = 5,
        type = 6,
        shape = 7,
        tensor = 8,
        placeholder = 9,
        func = 10,
    }
    ValueCase _valueCase = ValueCase.valueNotSet;
    @property ValueCase valueCase() { return _valueCase; }
    void clearValue() { _valueCase = ValueCase.valueNotSet; }
    @Oneof("_valueCase") union
    {
        @Proto(1) AttrValue.ListValue _list = protoDefaultValue!(AttrValue.ListValue); mixin(oneofAccessors!_list);
        @Proto(2) bytes _s; mixin(oneofAccessors!_s);
        @Proto(3) long _i; mixin(oneofAccessors!_i);
        @Proto(4) float _f; mixin(oneofAccessors!_f);
        @Proto(5) bool _b; mixin(oneofAccessors!_b);
        @Proto(6) DataType _type; mixin(oneofAccessors!_type);
        @Proto(7) TensorShapeProto _shape; mixin(oneofAccessors!_shape);
        @Proto(8) TensorProto _tensor; mixin(oneofAccessors!_tensor);
        @Proto(9) string _placeholder; mixin(oneofAccessors!_placeholder);
        @Proto(10) NameAttrList _func; mixin(oneofAccessors!_func);
    }

    static class ListValue
    {
        @Proto(2) bytes[] s = protoDefaultValue!(bytes[]);
        @Proto(3, Wire.none, Yes.packed) long[] i = protoDefaultValue!(long[]);
        @Proto(4, Wire.none, Yes.packed) float[] f = protoDefaultValue!(float[]);
        @Proto(5, Wire.none, Yes.packed) bool[] b = protoDefaultValue!(bool[]);
        @Proto(6) DataType[] type = protoDefaultValue!(DataType[]);
        @Proto(7) TensorShapeProto[] shape = protoDefaultValue!(TensorShapeProto[]);
        @Proto(8) TensorProto[] tensor = protoDefaultValue!(TensorProto[]);
        @Proto(9) NameAttrList[] func = protoDefaultValue!(NameAttrList[]);
    }
}

class NameAttrList
{
    @Proto(1) string name = protoDefaultValue!(string);
    @Proto(2) AttrValue[string] attr = protoDefaultValue!(AttrValue[string]);
}
