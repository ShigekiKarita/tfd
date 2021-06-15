// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: tensorflow/core/protobuf/graph_debug_info.proto

module tensorflow.graph_debug_info;

import google.protobuf;

enum protocVersion = 3012004;

class GraphDebugInfo
{
    @Proto(1) string[] files = protoDefaultValue!(string[]);
    @Proto(2) GraphDebugInfo.StackTrace[string] traces = protoDefaultValue!(GraphDebugInfo.StackTrace[string]);

    static class FileLineCol
    {
        @Proto(1) int fileIndex = protoDefaultValue!(int);
        @Proto(2) int line = protoDefaultValue!(int);
        @Proto(3) int col = protoDefaultValue!(int);
        @Proto(4) string func = protoDefaultValue!(string);
        @Proto(5) string code = protoDefaultValue!(string);
    }

    static class StackTrace
    {
        @Proto(1) GraphDebugInfo.FileLineCol[] fileLineCols = protoDefaultValue!(GraphDebugInfo.FileLineCol[]);
    }
}