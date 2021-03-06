// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: tensorflow/core/framework/kernel_def.proto

module tensorflow.kernel_def;

import google.protobuf;
import tensorflow.attr_value;

enum protocVersion = 3012004;

class KernelDef
{
    @Proto(1) string op = protoDefaultValue!(string);
    @Proto(2) string deviceType = protoDefaultValue!(string);
    @Proto(3) KernelDef.AttrConstraint[] constraint = protoDefaultValue!(KernelDef.AttrConstraint[]);
    @Proto(4) string[] hostMemoryArg = protoDefaultValue!(string[]);
    @Proto(5) string label = protoDefaultValue!(string);
    @Proto(6) int priority = protoDefaultValue!(int);

    static class AttrConstraint
    {
        @Proto(1) string name = protoDefaultValue!(string);
        @Proto(2) AttrValue allowedValues = protoDefaultValue!(AttrValue);
    }
}

class KernelList
{
    @Proto(1) KernelDef[] kernel = protoDefaultValue!(KernelDef[]);
}
