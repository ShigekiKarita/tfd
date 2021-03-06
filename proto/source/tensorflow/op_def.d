// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: tensorflow/core/framework/op_def.proto

module tensorflow.op_def;

import google.protobuf;
import tensorflow.attr_value;
import tensorflow.types;

enum protocVersion = 3012004;

class OpDef
{
    @Proto(1) string name = protoDefaultValue!(string);
    @Proto(2) OpDef.ArgDef[] inputArg = protoDefaultValue!(OpDef.ArgDef[]);
    @Proto(3) OpDef.ArgDef[] outputArg = protoDefaultValue!(OpDef.ArgDef[]);
    @Proto(4) OpDef.AttrDef[] attr = protoDefaultValue!(OpDef.AttrDef[]);
    @Proto(5) string summary = protoDefaultValue!(string);
    @Proto(6) string description = protoDefaultValue!(string);
    @Proto(8) OpDeprecation deprecation = protoDefaultValue!(OpDeprecation);
    @Proto(16) bool isAggregate = protoDefaultValue!(bool);
    @Proto(17) bool isStateful = protoDefaultValue!(bool);
    @Proto(18) bool isCommutative = protoDefaultValue!(bool);
    @Proto(19) bool allowsUninitializedInput = protoDefaultValue!(bool);
    @Proto(20) string[] controlOutput = protoDefaultValue!(string[]);

    static class ArgDef
    {
        @Proto(1) string name = protoDefaultValue!(string);
        @Proto(2) string description = protoDefaultValue!(string);
        @Proto(3) DataType type = protoDefaultValue!(DataType);
        @Proto(4) string typeAttr = protoDefaultValue!(string);
        @Proto(5) string numberAttr = protoDefaultValue!(string);
        @Proto(6) string typeListAttr = protoDefaultValue!(string);
        @Proto(16) bool isRef = protoDefaultValue!(bool);
    }

    static class AttrDef
    {
        @Proto(1) string name = protoDefaultValue!(string);
        @Proto(2) string type = protoDefaultValue!(string);
        @Proto(3) AttrValue defaultValue = protoDefaultValue!(AttrValue);
        @Proto(4) string description = protoDefaultValue!(string);
        @Proto(5) bool hasMinimum = protoDefaultValue!(bool);
        @Proto(6) long minimum = protoDefaultValue!(long);
        @Proto(7) AttrValue allowedValues = protoDefaultValue!(AttrValue);
    }
}

class OpDeprecation
{
    @Proto(1) int version_ = protoDefaultValue!(int);
    @Proto(2) string explanation = protoDefaultValue!(string);
}

class OpList
{
    @Proto(1) OpDef[] op = protoDefaultValue!(OpDef[]);
}
