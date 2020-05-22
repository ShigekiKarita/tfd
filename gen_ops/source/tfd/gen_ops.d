module tfd.gen_ops;

import pegged.grammar;
import tfd.pbtxt;


string codegen(ParseTree tree)
{
  assert(tree.name == "PbTxt.Dict");
  assert(tree.matches[0] == "op");

  string opname;
  // TODO
  int nin;
  foreach (child; tree.children)
  {
    switch (child.matches[0])
    {
      case "name":
        assert(child.name == "PbTxt.Pair");
        opname = child.matches[1];
        break;
      default:
        break;
    }
  }

  string option = `struct ` ~ opname ~ `Option {}`;
  
  return option ~ "\n" ~ "TF_Operation* " ~ opname ~
      `(TF_Graph* graph, TF_Status* status, string name, TF_Operation*[` ~ nin ~ `] inops) 
{
  import std.string : fromStringz;

  auto desc = TF_NewOperation(graph, "` ~ opname ~ `", name);
  TF_Output[` ~ nin ~ `] inputs;
  static foreach (i; 0 .. ` ~ nin ~ `)
  {
    inputs[i] = TF_Output(inops[i], 0);
  }
  TF_AddInputList(desc, inputs.ptr, inputs.length);
  TF_Operation* op = TF_FinishOperation(desc, status);
  assert(TF_GetCode(status) == TF_OK, TF_Message(status).fromStringz);
  return desc;
}`;
}

unittest
{
  import std;

  auto tree = PbTxt(exampleProto);
  auto root = tree.children[0];

  auto addN = root.children[0];
  writeln(codegen(addN));
  
  auto identity = root.children[1];
}
