// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: tensorflow/core/framework/log_memory.proto

module tensorflow.log_memory;

import google.protobuf;
import tensorflow.tensor_description;

enum protocVersion = 3012004;

class MemoryLogStep
{
    @Proto(1) long stepId = protoDefaultValue!(long);
    @Proto(2) string handle = protoDefaultValue!(string);
}

class MemoryLogTensorAllocation
{
    @Proto(1) long stepId = protoDefaultValue!(long);
    @Proto(2) string kernelName = protoDefaultValue!(string);
    @Proto(3) TensorDescription tensor = protoDefaultValue!(TensorDescription);
}

class MemoryLogTensorDeallocation
{
    @Proto(1) long allocationId = protoDefaultValue!(long);
    @Proto(2) string allocatorName = protoDefaultValue!(string);
}

class MemoryLogTensorOutput
{
    @Proto(1) long stepId = protoDefaultValue!(long);
    @Proto(2) string kernelName = protoDefaultValue!(string);
    @Proto(3) int index = protoDefaultValue!(int);
    @Proto(4) TensorDescription tensor = protoDefaultValue!(TensorDescription);
}

class MemoryLogRawAllocation
{
    @Proto(1) long stepId = protoDefaultValue!(long);
    @Proto(2) string operation = protoDefaultValue!(string);
    @Proto(3) long numBytes = protoDefaultValue!(long);
    @Proto(4) ulong ptr = protoDefaultValue!(ulong);
    @Proto(5) long allocationId = protoDefaultValue!(long);
    @Proto(6) string allocatorName = protoDefaultValue!(string);
}

class MemoryLogRawDeallocation
{
    @Proto(1) long stepId = protoDefaultValue!(long);
    @Proto(2) string operation = protoDefaultValue!(string);
    @Proto(3) long allocationId = protoDefaultValue!(long);
    @Proto(4) string allocatorName = protoDefaultValue!(string);
    @Proto(5) bool deferred = protoDefaultValue!(bool);
}
