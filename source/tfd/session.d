/// TF Session module.
module tfd.session;

import tensorflow.c_api;

import tfd.testing : assertStatus;


struct Session 
{
private:
  import std.typecons : Tuple;
  import std.container.array : Array;

  TF_Session* session_;
  alias session_ this;

  Array!TF_Output inputs_;
  Array!(TF_Tensor*) inputValues_;
  Array!TF_Output outputs_;
  Array!(TF_Tensor*) outputValues_;
  Array!(TF_Operation*) targets_;

  @nogc nothrow @trusted
  void deleteInputValues()
  {
    foreach (v; this.inputValues_) 
    {
      if (v)
      {
        TF_DeleteTensor(v);
      }
    }
    this.inputValues_.clear();
  }

  @nogc nothrow @trusted
  void deleteOutputValues()
  {
    foreach (v; this.outputValues_) 
    {
      if (v !is null)
      {
        TF_DeleteTensor(v);
      }
    }
    outputValues_.clear();
  }

public:

  /// Constructs a new session.
  @nogc nothrow @trusted
  this(scope TF_Graph* graph, scope TF_Status* s, bool useXLA = false)
  {
    // TODO(karita): support XLA
    assert(!useXLA, "XLA is not supported yet.");
    TF_SessionOptions* opts = TF_NewSessionOptions();
    scope (exit) TF_DeleteSessionOptions(opts);
    // TF_EnableXLACompilation(opts, useXLA);
    this.session_ = TF_NewSession(graph, opts, s);
    assertStatus(s);
  }

  @nogc nothrow @trusted
  ~this()
  {
    TF_Status* s = TF_NewStatus();
    this.closeAndDelete(s);
    assertStatus(s);
    TF_DeleteStatus(s);
  }

  /// Closes and deletes input/output values explicitly.
  @nogc nothrow @trusted
  void closeAndDelete(TF_Status* s) 
  {
    this.deleteInputValues();
    this.deleteOutputValues();
    if (session_ !is null) {
      TF_CloseSession(session_, s);
      assertStatus(s);
      TF_DeleteSession(session_, s);
      session_ = null;
    }
  }

  /// Sets input values.
  @nogc @trusted
  void setInputs(TF_Tensor*[TF_Operation*] inputs)
  {
    this.deleteInputValues();
    this.inputs_.clear();
    this.inputs_.reserve(inputs.length);
    this.inputValues_.reserve(inputs.length);
    foreach (op, tensor; inputs)
    {
      this.inputs_ ~= TF_Output(cast(TF_Operation*) op, 0);
      this.inputValues_ ~= tensor;
    }
  }

  /// Sets input values for nothrow @nogc usage.
  @nogc nothrow @trusted
  void setInputs(size_t N)(Tuple!(TF_Operation*, TF_Tensor*)[N] inputs...)
  {
    this.deleteInputValues();
    this.inputs_.clear();
    this.inputs_.reserve(inputs.length);
    this.inputValues_.reserve(inputs.length);
    foreach (opTensor; inputs)
    {
      this.inputs_ ~= TF_Output(cast(TF_Operation*) opTensor[0], 0);
      this.inputValues_ ~= opTensor[1];
    }
  }

  /// Sets output values.
  @nogc nothrow @trusted
  void setOutputs(size_t N)(TF_Operation*[N] outputs...)
  {
    this.deleteOutputValues();
    this.outputs_.clear();
    this.outputs_.reserve(N);
    foreach (op; outputs)
    {
      this.outputs_ ~= TF_Output(op, 0);
    }
    this.outputValues_.length = N;
  }

  /// Runs session to evaluate outputs by given inputs.
  @nogc nothrow @trusted
  void run(TF_Status* s)
  {
    assert(this.inputs_.length == this.inputValues_.length,
          "Call setInputs() before run()");
    this.deleteOutputValues();
    this.outputValues_.length = this.outputs_.length;

    const inputs_ptr = inputs_.empty ? null : &inputs_[0];
    auto input_values_ptr =
        inputValues_.empty ? null : &inputValues_[0];

    const TF_Output* outputs_ptr = 
        outputs_.empty ? null : &outputs_[0];
    TF_Tensor** outputValues_ptr =
        outputValues_.empty ? null : &outputValues_[0];

    const targets_ptr = targets_.empty ? null : &targets_[0];

    TF_SessionRun(
        session_, null, 
        inputs_ptr, input_values_ptr, cast(int) inputs_.length,
        outputs_ptr, outputValues_ptr, cast(int) outputs_.length, 
        targets_ptr, cast(int) targets_.length,
        null, s);
    this.deleteInputValues();
  }

  /// Runs in python-like usage.

}

/// CAPI Session test in `tensorflow/c/c_api_test.c`
unittest
{
  import tfd.graph : Add, Placeholder, ScalarConst;
  import tfd.tensor : makeTensor;

  TF_Status* s = TF_NewStatus();
  scope (exit) TF_DeleteStatus(s);
  TF_Graph* graph = TF_NewGraph();
  scope (exit) TF_DeleteGraph(graph);

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

  // run the graph.
  session.setInputs([feed: makeTensor(3)]);
  session.setOutputs(add);
  session.run(s);
  assertStatus(s);
  TF_Tensor* result = session.outputValues_[0];
  assert(result !is null);
  assert(TF_TensorType(result) == TF_INT32);
  int* resultVal = cast(int*) TF_TensorData(result);
  assert(2 + 3 == *resultVal);
}

/// CAPI Session test in `tensorflow/c/c_api_test.c` with @nogc usage.
@nogc
unittest
{
  import tfd.graph : Add, Placeholder, ScalarConst;
  import tfd.tensor : makeTensor;

  TF_Status* s = TF_NewStatus();
  scope (exit) TF_DeleteStatus(s);
  TF_Graph* graph = TF_NewGraph();
  scope (exit) TF_DeleteGraph(graph);

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

  // run the graph.
  import std.typecons : tuple;
  session.setInputs(tuple(feed, makeTensor(3)));
  session.setOutputs(add);
  session.run(s);
  assertStatus(s);
  TF_Tensor* result = session.outputValues_[0];
  assert(result !is null);
  assert(TF_TensorType(result) == TF_INT32);
  int* resultVal = cast(int*) TF_TensorData(result);
  assert(2 + 3 == *resultVal);
}