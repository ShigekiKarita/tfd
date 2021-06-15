#!/usr/bin/env dub
/+ dub.json:
{
  "dependencies": {
     "tfd": {"path": "../.."},
     "protobuf": {"path": "../../proto/protobuf-d"}
  },
  "libs": ["tensorflow"]
}
+/
module load_model;

import std.conv : to;
import std.stdio : File, writeln;
import std.traits : FieldNameTuple;

import tensorflow.saved_model : SavedModel;
import tensorflow.meta_graph : MetaGraphDef;
import google.protobuf;

void printFields(T)(T x) {
  writeln("=== ", T.stringof, " ===");
  foreach (i, field; FieldNameTuple!T) {
    writeln(field, ": ", x.tupleof[i]);
  }
}

void main() {
  auto input = File("mobilenet_v2/1/saved_model.pb", "rb");
  scope (exit) input.close();

  ubyte[] inputBuffer = input.rawRead(new ubyte[input.size.to!size_t]);
  auto savedModel = inputBuffer.fromProtobuf!SavedModel;
  foreach (graph; savedModel.metaGraphs) {
    printFields(graph.metaInfoDef);

    writeln("=== Signature ===");
    foreach (k, v; graph.signatureDef) {
      writeln("key: ", k);
      printFields(v);
    }
  }
}
