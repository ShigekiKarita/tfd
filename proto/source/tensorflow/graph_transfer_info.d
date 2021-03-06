// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: tensorflow/core/framework/graph_transfer_info.proto

module tensorflow.graph_transfer_info;

import google.protobuf;
import tensorflow.types;

enum protocVersion = 3012004;

class GraphTransferNodeInput
{
    @Proto(1) int nodeId = protoDefaultValue!(int);
    @Proto(2) int outputPort = protoDefaultValue!(int);
}

class GraphTransferNodeInfo
{
    @Proto(1) string name = protoDefaultValue!(string);
    @Proto(2) int nodeId = protoDefaultValue!(int);
    @Proto(3) string typeName = protoDefaultValue!(string);
    @Proto(4) int socOpId = protoDefaultValue!(int);
    @Proto(5) int paddingId = protoDefaultValue!(int);
    @Proto(6) int inputCount = protoDefaultValue!(int);
    @Proto(7) int outputCount = protoDefaultValue!(int);
}

class GraphTransferConstNodeInfo
{
    @Proto(1) string name = protoDefaultValue!(string);
    @Proto(2) int nodeId = protoDefaultValue!(int);
    @Proto(3, Wire.none, Yes.packed) long[] shape = protoDefaultValue!(long[]);
    @Proto(4) bytes data = protoDefaultValue!(bytes);
    @Proto(5) DataType dtype = protoDefaultValue!(DataType);
}

class GraphTransferNodeInputInfo
{
    @Proto(1) int nodeId = protoDefaultValue!(int);
    @Proto(2) GraphTransferNodeInput[] nodeInput = protoDefaultValue!(GraphTransferNodeInput[]);
}

class GraphTransferNodeOutputInfo
{
    @Proto(1) int nodeId = protoDefaultValue!(int);
    @Proto(2, Wire.none, Yes.packed) int[] maxByteSize = protoDefaultValue!(int[]);
}

class GraphTransferGraphInputNodeInfo
{
    @Proto(1) string name = protoDefaultValue!(string);
    @Proto(2, Wire.none, Yes.packed) long[] shape = protoDefaultValue!(long[]);
    @Proto(3) DataType dtype = protoDefaultValue!(DataType);
}

class GraphTransferGraphOutputNodeInfo
{
    @Proto(1) string name = protoDefaultValue!(string);
    @Proto(2, Wire.none, Yes.packed) long[] shape = protoDefaultValue!(long[]);
    @Proto(3) DataType dtype = protoDefaultValue!(DataType);
}

class GraphTransferInfo
{
    @Proto(1) GraphTransferNodeInfo[] nodeInfo = protoDefaultValue!(GraphTransferNodeInfo[]);
    @Proto(2) GraphTransferConstNodeInfo[] constNodeInfo = protoDefaultValue!(GraphTransferConstNodeInfo[]);
    @Proto(3) GraphTransferNodeInputInfo[] nodeInputInfo = protoDefaultValue!(GraphTransferNodeInputInfo[]);
    @Proto(4) GraphTransferNodeOutputInfo[] nodeOutputInfo = protoDefaultValue!(GraphTransferNodeOutputInfo[]);
    @Proto(5) GraphTransferGraphInputNodeInfo[] graphInputNodeInfo = protoDefaultValue!(GraphTransferGraphInputNodeInfo[]);
    @Proto(6) GraphTransferGraphOutputNodeInfo[] graphOutputNodeInfo = protoDefaultValue!(GraphTransferGraphOutputNodeInfo[]);
    @Proto(7) Destination destination = protoDefaultValue!(Destination);

    enum Destination
    {
        NOP = 0,
        HEXAGON = 1,
    }
}
