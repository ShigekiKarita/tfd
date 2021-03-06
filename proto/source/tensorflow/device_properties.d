// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: tensorflow/core/protobuf/device_properties.proto

module tensorflow.device_properties;

import google.protobuf;

enum protocVersion = 3012004;

class DeviceProperties
{
    @Proto(1) string type = protoDefaultValue!(string);
    @Proto(2) string vendor = protoDefaultValue!(string);
    @Proto(3) string model = protoDefaultValue!(string);
    @Proto(4) long frequency = protoDefaultValue!(long);
    @Proto(5) long numCores = protoDefaultValue!(long);
    @Proto(6) string[string] environment = protoDefaultValue!(string[string]);
    @Proto(7) long numRegisters = protoDefaultValue!(long);
    @Proto(8) long l1CacheSize = protoDefaultValue!(long);
    @Proto(9) long l2CacheSize = protoDefaultValue!(long);
    @Proto(10) long l3CacheSize = protoDefaultValue!(long);
    @Proto(11) long sharedMemorySizePerMultiprocessor = protoDefaultValue!(long);
    @Proto(12) long memorySize = protoDefaultValue!(long);
    @Proto(13) long bandwidth = protoDefaultValue!(long);
}

class NamedDevice
{
    @Proto(1) string name = protoDefaultValue!(string);
    @Proto(2) DeviceProperties properties = protoDefaultValue!(DeviceProperties);
}
