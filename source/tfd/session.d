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
    this.inputValues_.clear();
    this.outputValues_.clear();
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
    this.inputValues_.clear();
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
    this.inputValues_.clear();
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
    this.outputValues_.clear();
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
    scope (exit) this.inputValues_.clear();
    this.outputValues_.length = this.outputs_.length;

    const inputsPtr = inputs_.empty ? null : &inputs_[0];
    auto inputValuesPtr =
        inputValues_.empty ? null : &inputValues_[0];

    const TF_Output* outputsPtr = 
        outputs_.empty ? null : &outputs_[0];
    TF_Tensor** outputValuesPtr =
        outputValues_.empty ? null : &outputValues_[0];

    const targetsPtr = targets_.empty ? null : &targets_[0];

    TF_SessionRun(
        session_, null, 
        inputsPtr, inputValuesPtr, cast(int) inputs_.length,
        outputsPtr, outputValuesPtr, cast(int) outputs_.length, 
        targetsPtr, cast(int) targets_.length,
        null, s);
    assertStatus(s);
  }

  /// Runs in python-like usage.　
  /// WARNING: you need to free the returned tensors by yourself.
  TF_Tensor*[N] run(size_t N)(TF_Operation*[N] outputs, TF_Tensor*[TF_Operation*] inputs)
  {
    this.setInputs(inputs);
    this.setOutputs(outputs);
    auto s = TF_NewStatus();
    scope (exit) TF_DeleteStatus(s);
    this.run(s);
    TF_Tensor*[N] ret;
    foreach (i; 0 .. N)
    {
      ret[i] = this.outputValues_[i];
    }
    return ret;
  }
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
  TF_Tensor* feedVal = makeTensor(3);
  scope (exit) TF_DeleteTensor(feedVal);
  TF_Tensor* addVal = session.run([add], [feed: feedVal])[0];
  scope (exit) TF_DeleteTensor(addVal);

  assert(TF_TensorType(addVal) == TF_INT32);
  int* addInt = cast(int*) TF_TensorData(addVal);
  assert(2 + 3 == *addInt);
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

  TF_Tensor* feedVal = makeTensor(3);
  scope (exit) TF_DeleteTensor(feedVal);
  session.setInputs(tuple(feed, feedVal));
  session.setOutputs(add);
  session.run(s);
  assertStatus(s);
  TF_Tensor* addVal = session.outputValues_[0];
  scope (exit) TF_DeleteTensor(addVal);
  assert(addVal !is null);
  assert(TF_TensorType(addVal) == TF_INT32);
  int* addInt = cast(int*) TF_TensorData(addVal);
  assert(2 + 3 == *addInt);
}