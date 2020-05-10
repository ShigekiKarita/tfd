#!/usr/bin/env dub
/+ dub.json:
{
  "dependencies": {
     "tfd": {"path": "../.."}
  }
}
+/
import std.stdio : writeln;
import std.file : read;
import tfd : newGraph, tensor;

void main()
{
  with (newGraph) {
    // TODO(karita): pbtxt support.
    load(read("add-py.bin"));
    auto a = operationByName("a");
    auto add = operationByName("add");

    const t = session.run([add], [a: 1.tensor])[0].tensor;
    assert(t.scalar!int == 1 + 3);
    writeln(t.scalar!int);
  }
}