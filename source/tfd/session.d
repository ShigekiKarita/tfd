/// TF Session module.
module tfd.session;

import tfd.c_api;
import tfd.graph : Operation;
import tfd.tensor : Tensor;
import tfd.testing : assertStatus;


/// Wrapper class for TF_Session.
struct Session
{
  import tfd.tensor : Tensor, TensorOwner;
  import tfd.graph : Operation;

  /// Raw session data.
  TF_Session* base;
  alias base this;

  /// Status
  TF_Status* status;

  /// Not copyable
  @disable this(this);

  /// Constructs a new session.
  @nogc nothrow @trusted
  this(scope TF_Graph* graph, bool useXLA = false)
  {
    // TODO(karita): support XLA
    assert(!useXLA, "XLA is not supported yet.");
    this.status = TF_NewStatus();
    TF_SessionOptions* opts = TF_NewSessionOptions();
    scope (exit) TF_DeleteSessionOptions(opts);
    // TF_EnableXLACompilation(opts, useXLA);
    this.base = TF_NewSession(graph, opts, this.status);
    assertStatus(this.status);
  }

   @nogc nothrow @trusted
  ~this()
  {
    this.close();
    TF_DeleteStatus(this.status);
  }

  /// Closes and deletes input/output values explicitly.
  @nogc nothrow @trusted
  void close()
  {
    if (base !is null)
    {
      TF_CloseSession(base, this.status);
      assertStatus(this.status);
      TF_DeleteSession(base, this.status);
      assertStatus(this.status);
      base = null;
    }
  }

  /// Runs session to evaluate outputs by given inputs.
  @nogc nothrow @trusted
  void run(Operation[] inputs, Tensor[] inputValues,
           Operation[] outputs, Tensor[] outputValues,
           Operation[] targets = [])
  {
    import std.container.array : Array;
    import std.range : empty;

    import mir.rc.slim_ptr : createSlimRC;

    assert(inputs.length == inputValues.length);
    assert(outputs.length == outputValues.length);

    Array!TF_Output baseInputs;
    baseInputs.reserve(inputs.length);
    foreach (x; inputs)
    {
      baseInputs ~= TF_Output(x.base);
    }

    Array!TF_Output baseOutputs;
    baseInputs.reserve(outputs.length);
    foreach (x; outputs)
    {
      baseOutputs ~= TF_Output(x.base);
    }

    Array!(TF_Tensor*) baseInputValues;
    baseInputValues.reserve(inputValues.length);
    foreach (x; inputValues)
    {
      baseInputValues ~= x.base;
    }

    Array!(TF_Tensor*) baseOutputValues;
    baseOutputValues.length = outputValues.length;

    Array!(TF_Operation*) baseTargets;
    baseInputs.reserve(targets.length);
    foreach (x; targets)
    {
      baseTargets ~= x.base;
    }

    TF_SessionRun(
        this.base, null,
        inputs.empty ? null : &baseInputs[0], &baseInputValues[0], cast(int) inputs.length,
        outputs.empty ? null : &baseOutputs[0], &baseOutputValues[0], cast(int) outputs.length,
        targets.empty ? null : &baseTargets[0], cast(int) targets.length,
        null, this.status);
    assertStatus(this.status);

    foreach (i; 0 .. outputs.length)
    {
      outputValues[i] = createSlimRC!TensorOwner(baseOutputValues[i]);
    }
  }

  /// Runs in python-like usage.
  nothrow @trusted
  Tensor[N] run(size_t N)(Operation[N] outputs, Tensor[Operation] inputs)
  {
    Tensor[N] ret;
    this.run(inputs.keys, inputs.values, outputs[], ret[]);
    return ret;
  }

}


/// nothrow, nogc, and safe usage
@nogc nothrow @safe
unittest
{
  import std.typecons : tuple;
  import tfd.tensor : tensor, Tensor;
  import tfd.graph : newGraph, Operation;

  with (newGraph)
  {
    Operation x = placeholder!int("x");
    Operation two = constant(2);
    Operation add = x + two;

    Operation[1] inops;
    inops[0] = x;
    Tensor[1] inputs;
    inputs[0] = 3.tensor;
    Operation[1] outops;
    outops[0] = add;
    Tensor[1] outputs;
    session.run(inops, inputs, outops, outputs);
    assert(outputs[0].scalar!int == 5);

    write("tmp.pb");
  }
  with (newGraph)
  {
    read("tmp.pb");
    // auto x = operationByName("x");
    // auto add = operationByName("add");
  }
}

/// TODO(karita): more interesting example. e.g., logistic regression.
unittest
{
  import tfd;

  /// scalar add
  with (newGraph)
  {
    Operation x = placeholder!int("x");
    Operation two = constant(2);
    Operation add = x + two;

    Tensor addVal = session.run([add], [x: 3.tensor])[0];
    assert(addVal.scalar!int == 5);
  }

  /// tensor add
  with (newGraph)
  {
    import mir.ndslice : as, iota;

    auto i = iota(2, 3, 4).as!float;

    Operation x = placeholder!float("x", 2, 3, 4);
    Operation two = constant(i);
    Operation add = x + two;

    Tensor addVal = session.run([add], [x: i.tensor])[0];
    assert(addVal.sliced!(float, 3) == i * 2);
  }
}
