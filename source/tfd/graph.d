// -*- c-basic-style: google, c-basic-offset: 2 -*-

/// TF Graph wrapper
module tfd.graph;

import std.string : fromStringz;

import tensorflow.c_api;
import tensorflow.op_def_pb;

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
  assert(TF_GetCode(s) == TF_OK, TF_Message(s).fromStringz);
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


/// Asserts TF_Status and shows message if failed.
@nogc nothrow @trusted
void assertStatus(TF_Status* s)
{
  assert(TF_GetCode(s) == TF_OK, TF_Message(s).fromStringz);
}


// TODO(karita): support all dtypes in TF
enum dtype(T: int) = TF_INT32;


/// Creates a tensor with dtype of T.
TF_Tensor* makeTensor(T, size_t num_dims)(
  const long[num_dims] dims, const(T)* values) 
{
  import core.stdc.string : memcpy;

  size_t num_values = 1;
  foreach (d; dims) {
    num_values *= d;
  }

  static if (num_dims == 0)
  {
    auto dimsPtr = null;
  }
  else
  {
    auto dimsPtr = dims.ptr;
  }
  TF_Tensor* t = TF_AllocateTensor(
      dtype!T, dimsPtr, num_dims, T.sizeof * num_values);
  memcpy(TF_TensorData(t), values, T.sizeof * num_values);
  return t;
}


/// Creates a tensor with a given scalar.
TF_Tensor* makeTensor(T)(const(T) scalar)
{
  long[0] dims;
  return makeTensor!(T, 0)(dims, &scalar);
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
unittest
{
  import std.stdio;
  writeln("CAPI Graph test");

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

struct Session 
{
  import std.container.array : Array;
  import std.typecons : Tuple;

  TF_Session* session_;
  alias session_ this;

  Array!TF_Output inputs_;
  Array!(TF_Tensor*) input_values_;
  Array!TF_Output outputs_;
  Array!(TF_Tensor*) output_values_;
  Array!(TF_Operation*) targets_;

  void DeleteInputValues()
  {
    foreach (v; this.input_values_) 
    {
      TF_DeleteTensor(v);
    }
    this.input_values_.clear();
  }

  void ResetOutputValues()
  {
    foreach (v; this.output_values_) 
    {
      if (v !is null)
      {
        TF_DeleteTensor(v);
      }
    }
    output_values_.clear();
  }

public:

  /// Constructs a new session.
  this(TF_Graph* graph, TF_Status* s, bool useXLA = false)
  {
    TF_SessionOptions* opts = TF_NewSessionOptions();
    // TODO(karita): support XLA
    assert(!useXLA, "XLA is not supported yet.");
    // TF_EnableXLACompilation(opts, useXLA);
    this.session_ = TF_NewSession(graph, opts, s);
    TF_DeleteSessionOptions(opts);
  }

  ~this()
  {
    TF_Status* s = TF_NewStatus();
    this.CloseAndDelete(s);
    assertStatus(s);
    TF_DeleteStatus(s);
  }

  /// Closes and deletes input/output values explicitly.
  void CloseAndDelete(TF_Status* s) 
  {
    DeleteInputValues();
    ResetOutputValues();
    if (session_ !is null) {
      TF_CloseSession(session_, s);
      assertStatus(s);
      TF_DeleteSession(session_, s);
      session_ = null;
    }
  }

  /// Sets input values.
  void SetInputs(TF_Tensor*[TF_Operation*] inputs)
  {
    this.DeleteInputValues();
    this.inputs_.clear();
    this.inputs_.reserve(inputs.length);
    this.input_values_.reserve(inputs.length);
    foreach (op, tensor; inputs)
    {
      this.inputs_ ~= TF_Output(cast(TF_Operation*) op, 0);
      this.input_values_ ~= tensor;
    }
  }

  /// Sets output values.
  void SetOutputs(size_t N)(TF_Operation*[N] outputs...)
  {
    this.ResetOutputValues();
    this.outputs_.clear();
    this.outputs_.reserve(N);
    foreach (op; outputs)
    {
      this.outputs_ ~= TF_Output(op, 0);
    }
    this.output_values_.length = N;
  }

  void Run(TF_Status* s)
  {
    assert(this.inputs_.length == input_values_.length,
          "Call SetInputs() before Run()");
    this.ResetOutputValues();
    this.output_values_.length = this.outputs_.length;

    const inputs_ptr = inputs_.empty ? null : &inputs_[0];
    auto input_values_ptr =
        input_values_.empty ? null : &input_values_[0];

    const TF_Output* outputs_ptr = 
        outputs_.empty ? null : &outputs_[0];
    TF_Tensor** output_values_ptr =
        output_values_.empty ? null : &output_values_[0];

    const targets_ptr = targets_.empty ? null : &targets_[0];

    TF_SessionRun(
        session_, null, 
        inputs_ptr, input_values_ptr, cast(int) inputs_.length,
        outputs_ptr, output_values_ptr, cast(int) outputs_.length, 
        targets_ptr, cast(int) targets_.length,
        null, s);
    this.DeleteInputValues();
  }
}

/// CAPI Session test in `tensorflow/c/c_api_test.c`
unittest
{
  TF_Status* s = TF_NewStatus();
  TF_Graph* graph = TF_NewGraph();

  // Make a placeholder operation.
  TF_Operation* feed = Placeholder(graph, s);
  assertStatus(s);

  // Make a constant operation with the scalar "2".
  TF_Operation* two = ScalarConst(2, graph, s);
  assertStatus(s);

  // Add operation.
  TF_Operation* add = Add(feed, two, graph, s);
  assertStatus(s);

  // Create a session for this graph.
  auto session = Session(graph, s);
  assertStatus(s);

  // Run the graph.
  import std.typecons : tuple;
  session.SetInputs([feed: makeTensor(3)]);
  session.SetOutputs(add);
  session.Run(s);
  assertStatus(s);
  TF_Tensor* result = session.output_values_[0];
  assert(result !is null);
  assert(TF_TensorType(result) == TF_INT32);
  int* resultVal = cast(int*) TF_TensorData(result);
  assert(2 + 3 == *resultVal);
}

