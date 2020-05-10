#!/usr/bin/env dub
/+ dub.json:
{
  "dependencies": {
     "tfd": {"path": "../.."}
  }
}
+/
import tfd : newGraph;

void main()
{
  with (newGraph) {
    auto a = placeholder!int("a");
    auto b = constant(3, "b");
    // TODO(karita): provide name "add" by identity
    auto add = a + b;
    write("add-d.bin");
  }
}