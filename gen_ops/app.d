import tfd.pbtxt;

import std.stdio;


void main()
{
  auto txt = import("tensorflow/core/ops/ops.pbtxt");
  auto tree = PbTxt(txt);
  assert(tree.successful);
  assert(tree.name == "PbTxt");
  assert(tree.children.length == 1);

  auto root = tree.children[0];
  assert(root.name == "PbTxt.Root");

  auto op = root.children[0];
  assert(op.name == "PbTxt.Dict");
  assert(op.matches[0] == "op");

  
  writefln!"%d ops found."(root.children.length);
}
