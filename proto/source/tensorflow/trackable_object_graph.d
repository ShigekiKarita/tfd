// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: tensorflow/core/protobuf/trackable_object_graph.proto

module tensorflow.trackable_object_graph;

import google.protobuf;

enum protocVersion = 3012004;

class TrackableObjectGraph
{
    @Proto(1) TrackableObjectGraph.TrackableObject[] nodes = protoDefaultValue!(TrackableObjectGraph.TrackableObject[]);

    static class TrackableObject
    {
        @Proto(1) TrackableObjectGraph.TrackableObject.ObjectReference[] children = protoDefaultValue!(TrackableObjectGraph.TrackableObject.ObjectReference[]);
        @Proto(2) TrackableObjectGraph.TrackableObject.SerializedTensor[] attributes = protoDefaultValue!(TrackableObjectGraph.TrackableObject.SerializedTensor[]);
        @Proto(3) TrackableObjectGraph.TrackableObject.SlotVariableReference[] slotVariables = protoDefaultValue!(TrackableObjectGraph.TrackableObject.SlotVariableReference[]);

        static class ObjectReference
        {
            @Proto(1) int nodeId = protoDefaultValue!(int);
            @Proto(2) string localName = protoDefaultValue!(string);
        }

        static class SerializedTensor
        {
            @Proto(1) string name = protoDefaultValue!(string);
            @Proto(2) string fullName = protoDefaultValue!(string);
            @Proto(3) string checkpointKey = protoDefaultValue!(string);
            @Proto(4) bool optionalRestore = protoDefaultValue!(bool);
        }

        static class SlotVariableReference
        {
            @Proto(1) int originalVariableNodeId = protoDefaultValue!(int);
            @Proto(2) string slotName = protoDefaultValue!(string);
            @Proto(3) int slotVariableNodeId = protoDefaultValue!(int);
        }
    }
}
