// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: tensorflow/core/protobuf/trace_events.proto

module tensorflow.profiler.trace_events;

import google.protobuf;

enum protocVersion = 3012004;

class Trace
{
    @Proto(1) Device[uint] devices = protoDefaultValue!(Device[uint]);
    @Proto(4) TraceEvent[] traceEvents = protoDefaultValue!(TraceEvent[]);
}

class Device
{
    @Proto(1) string name = protoDefaultValue!(string);
    @Proto(2) uint deviceId = protoDefaultValue!(uint);
    @Proto(3) Resource[uint] resources = protoDefaultValue!(Resource[uint]);
}

class Resource
{
    @Proto(1) string name = protoDefaultValue!(string);
    @Proto(2) uint resourceId = protoDefaultValue!(uint);
}

class TraceEvent
{
    @Proto(1) uint deviceId = protoDefaultValue!(uint);
    @Proto(2) uint resourceId = protoDefaultValue!(uint);
    @Proto(3) string name = protoDefaultValue!(string);
    @Proto(9) ulong timestampPs = protoDefaultValue!(ulong);
    @Proto(10) ulong durationPs = protoDefaultValue!(ulong);
    @Proto(11) string[string] args = protoDefaultValue!(string[string]);
}