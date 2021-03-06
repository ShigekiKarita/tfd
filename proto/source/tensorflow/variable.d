// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: tensorflow/core/framework/variable.proto

module tensorflow.variable;

import google.protobuf;

enum protocVersion = 3012004;

class VariableDef
{
    @Proto(1) string variableName = protoDefaultValue!(string);
    @Proto(2) string initializerName = protoDefaultValue!(string);
    @Proto(3) string snapshotName = protoDefaultValue!(string);
    @Proto(4) SaveSliceInfoDef saveSliceInfoDef = protoDefaultValue!(SaveSliceInfoDef);
    @Proto(5) bool isResource = protoDefaultValue!(bool);
    @Proto(6) string initialValueName = protoDefaultValue!(string);
    @Proto(7) bool trainable = protoDefaultValue!(bool);
    @Proto(8) VariableSynchronization synchronization = protoDefaultValue!(VariableSynchronization);
    @Proto(9) VariableAggregation aggregation = protoDefaultValue!(VariableAggregation);
}

class SaveSliceInfoDef
{
    @Proto(1) string fullName = protoDefaultValue!(string);
    @Proto(2, Wire.none, Yes.packed) long[] fullShape = protoDefaultValue!(long[]);
    @Proto(3, Wire.none, Yes.packed) long[] varOffset = protoDefaultValue!(long[]);
    @Proto(4, Wire.none, Yes.packed) long[] varShape = protoDefaultValue!(long[]);
}

enum VariableSynchronization
{
    VARIABLE_SYNCHRONIZATION_AUTO = 0,
    VARIABLE_SYNCHRONIZATION_NONE = 1,
    VARIABLE_SYNCHRONIZATION_ON_WRITE = 2,
    VARIABLE_SYNCHRONIZATION_ON_READ = 3,
}

enum VariableAggregation
{
    VARIABLE_AGGREGATION_NONE = 0,
    VARIABLE_AGGREGATION_SUM = 1,
    VARIABLE_AGGREGATION_MEAN = 2,
    VARIABLE_AGGREGATION_ONLY_FIRST_REPLICA = 3,
}
