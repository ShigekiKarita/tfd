// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: tensorflow/core/framework/graph.proto

module tensorflow.graph;

import google.protobuf;
import tensorflow.node_def;
import tensorflow.function_;
import tensorflow.versions;

enum protocVersion = 3012004;

class GraphDef
{
    @Proto(1) NodeDef[] node = protoDefaultValue!(NodeDef[]);
    @Proto(2) FunctionDefLibrary library = protoDefaultValue!(FunctionDefLibrary);
    @Proto(3) int version_ = protoDefaultValue!(int);
    @Proto(4) VersionDef versions = protoDefaultValue!(VersionDef);
}
