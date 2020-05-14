#!/usr/bin/env dub
/+ dub.json:
{
  "dependencies": {
     "tfd": {"path": "../.."}
  }
}
+/
import std.stdio : writeln;
import tfd : newGraph, tensor;

void main()
{
  with (newGraph)
  {
    read("add-py.bin");
    auto a = getOperationByName("a");
    auto add = getOperationByName("add");
    const t = session.run([add], [a: 1.tensor])[0].tensor;
    assert(t.scalar!int == 1 + 3);
    writeln(t.scalar!int);
  }
}
