/// TF_Graph wrapper.
module tfd.graph;

import std.string : fromStringz;

import tensorflow.c_api;
import tensorflow.op_def_pb;

import tfd.testing : assertStatus;

/// Creates a new placeholder in a given graph.
@nogc nothrow @trusted
TF_Operation* Placeholder(size_t N = 0)(
    TF_Graph* graph,
    TF_Status* s,
    const(char)* name = "feed",
    TF_DataType dtype = TF_INT32,
    const long[N] dims = [])
{
  TF_Operation* op;
  TF_OperationDescription* desc = TF_NewOperation(graph, "Placeholder", name);
  TF_SetAttrType(desc, "dtype", dtype);
  static if (N != 0)
  {
    TF_SetAttrShape(desc, "shape", dims.ptr, dims.length);
  }
  op = TF_FinishOperation(desc, s);
  assertStatus(s);
  assert(op);
  return op;
}

alias AttrValue = Tensorflow__AttrValue;

/// Gets an AttrValue from a given operation.
@nogc nothrow @trusted
bool GetAttrValue(
    TF_Operation* oper, const(char)* attr_name,
    AttrValue* attr_value, TF_Status* s)
{
  TF_Buffer* buffer = TF_NewBuffer();
  scope (exit) TF_DeleteBuffer(buffer);

  TF_OperationGetAttrValueProto(oper, attr_name, buffer, s);
  bool ret = TF_GetCode(s) == TF_OK;
  if (ret)
  {
    auto unpacked = tensorflow__attr_value__unpack(
        null,
        buffer.length,
        cast(const(ubyte)*) buffer.data);
    ret = (unpacked !is null);
    if (ret) *attr_value = *unpacked;
  }
  return ret;
}

/// Creates a const tensor.
@nogc nothrow @trusted
TF_Operation* Const(
    TF_Tensor* t,
    TF_Graph* graph,
    TF_Status* s,
    const(char)* name = "const")
{
  TF_Operation* op;
  TF_OperationDescription* desc = TF_NewOperation(graph, "Const", name);
  TF_SetAttrTensor(desc, "value", t, s);
  TF_SetAttrType(desc, "dtype", TF_TensorType(t));
  op = TF_FinishOperation(desc, s);
  assertStatus(s);
  assert(op !is null);
  return op;
}


/// Creates a scalar const tensor.
@nogc nothrow @trusted
TF_Operation* ScalarConst(int v, TF_Graph* graph, TF_Status* s,
                          const(char)* name = "scalar") 
{
  import tfd.tensor : makeTensor;
  // TODO(karita): free this tensor
  return Const(makeTensor(v), graph, s, name);
}


/// Adds two tensors.
@nogc nothrow @trusted
TF_Operation* Add(TF_Operation* l, TF_Operation* r, TF_Graph* graph,
                  TF_Status* s, const(char)* name = "add") {
  TF_OperationDescription* desc = TF_NewOperation(graph, "AddN", name);
  TF_Output[2] inputs;
  inputs[0] = TF_Output(l, 0);
  inputs[1] = TF_Output(r, 0);
  TF_AddInputList(desc, inputs.ptr, 2);
  TF_Operation* op = TF_FinishOperation(desc, s);
  assertStatus(s);
  assert(op !is null);
  return op;
}

/// ditto
TF_Operation* Add(TF_Output l, TF_Output r,
                  TF_Graph* graph, TF_Status* s,
                  const(char)* name = "add") {
  TF_OperationDescription* desc = TF_NewOperation(graph, "AddN", name);
  TF_Output[2] inputs;
  inputs[0] = l;
  inputs[1] = r;
  TF_AddInputList(desc, inputs.ptr, 2);
  return TF_FinishOperation(desc, s);
}

/// CAPI Graph test in `tensorflow/c/c_api_test.c`
@nogc nothrow
unittest
{
  TF_Status* s = TF_NewStatus();
  TF_Graph* graph = TF_NewGraph();

  // Make a placeholder operation.
  TF_Operation* feed = Placeholder(graph, s);
  assertStatus(s);

  // Test TF_Operation*() query functions.
  assert(TF_OperationName(feed).fromStringz == "feed");
  assert(TF_OperationOpType(feed).fromStringz == "Placeholder");
  assert(TF_OperationDevice(feed).fromStringz == "");
  assert(TF_OperationNumOutputs(feed) == 1);
  assert(TF_OperationOutputType(TF_Output(feed, 0)) == TF_INT32);
  assert(TF_OperationOutputListLength(feed, "output", s) == 1);
  assertStatus(s);
  assert(TF_OperationNumInputs(feed) == 0);
  assert(TF_OperationOutputNumConsumers(TF_Output(feed, 0)) == 0);
  assert(TF_OperationNumControlInputs(feed) == 0);
  assert(TF_OperationNumControlOutputs(feed) == 0);

  // TODO(karita): implement AttrValue type switching by `value_case`
  AttrValue attrValue;
  assert(GetAttrValue(feed, "dtype", &attrValue, s));
  assert(attrValue.type == TENSORFLOW__DATA_TYPE__DT_INT32);

  // Test not found errors in TF_Operation*() query functions.
  assert(TF_OperationOutputListLength(feed, "bogus", s) == -1);
  assert(TF_GetCode(s) == TF_INVALID_ARGUMENT);
  assert(!GetAttrValue(feed, "missing", &attrValue, s));
  assert(TF_Message(s).fromStringz ==
         "Operation 'feed' has no attr named 'missing'.");

  // Make a constant oper with the scalar "3".
  TF_Operation* three = ScalarConst(3, graph, s);
  assertStatus(s);
  // Add oper.
  Add(feed, three, graph, s);
  assertStatus(s);
}
