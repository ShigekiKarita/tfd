/// TF_Graph wrapper.
module tfd.graph;

import std.string : fromStringz;

import mir.rc.slim_ptr : createSlimRC, SlimRCPtr;

import tfd.c_api;
import tfd.testing : assertStatus;


/// TF_Graph freed by dtor (RAII) with convinient methods.
struct GraphOwner
{
  /// Raw pointer.
  TF_Graph* ptr;
  /// Status pointer.
  TF_Status* status;
  alias ptr this;

  // Not copyable.
  @disable this(this);

  @nogc nothrow @trusted
  ~this()
  {
    TF_DeleteGraph(this.ptr);
    TF_DeleteStatus(this.status);
  }

  /// Loads serialized graph (GraphDef proto).
  @nogc nothrow @trusted
  void deserialize(const(void)[] proto)
  {
    auto buffer = TF_NewBufferFromString(proto.ptr, proto.length);
    scope (exit) TF_DeleteBuffer(buffer);
    auto opts = TF_NewImportGraphDefOptions;
    TF_GraphImportGraphDef(this.ptr, buffer, opts, this.status);
    assertStatus(this.status);
  }

  /// Returns serialized bytes (GraphDef proto).
  @nogc nothrow @system
  TF_Buffer* serialize()
  {
    auto buffer = TF_NewBuffer;
    TF_GraphToGraphDef(this.ptr, buffer, this.status);
    assertStatus(this.status);
    return buffer;
  }

  // Reads serialized bytes (GraphDef proto) from file.
  @nogc nothrow @trusted
  void read(const(char)* fileName, size_t block = 1024)
  {
    import core.stdc.stdio : feof, fopen, fread;
    import core.stdc.stdlib : free, realloc;
    
    size_t len;
    void* buffer = realloc(null, block);
    assert(buffer, "realloc failed");
    scope (exit) free(buffer);

    void* ptr = realloc(null, block);
    assert(ptr, "realloc failed");
    scope (exit) free(ptr);

    auto fp = fopen(fileName, "rb");
    while (!feof(fp))
    {
       auto inc = fread(ptr, 1, block, fp);
       len += inc;
       ptr = realloc(ptr, len + block);
       assert(ptr, "realloc failed");
    }
    this.deserialize(ptr[0 .. len]);
  }

  /// Writes serialized bytes (GraphDef proto) to a given file.
  @nogc nothrow @trusted
  void write(const(char)* fileName)
  {
    import core.stdc.stdio : fopen, fwrite;

    auto buffer = this.serialize();
    scope (exit) TF_DeleteBuffer(buffer);
    auto fp = fopen(fileName, "wb");
    fwrite(buffer.data, 1, buffer.length, fp);
  }
}


/// Shared GraphOwner type.
struct Graph
{
  import tfd.session : Session;
  import tfd.tensor : tfType;
  import tfd.op : Operation;

  /// Base reference counted pointer.
  SlimRCPtr!GraphOwner base;
  alias base this;

  /// Get an operation by name
  @nogc nothrow @trusted
  bool hasOperationByName(const(char)* name)
  {
    auto opr = TF_GraphOperationByName(this.ptr, name);
    return opr !is null;
  }
  
  @nogc nothrow @trusted
  Operation getOperationByName(const(char)* name)
  {
    auto opr = TF_GraphOperationByName(this.ptr, name);
    assert(opr);
    return Operation(opr, this);
  }

  /// Creates a placeholder in this graph.
  @trusted
  Operation placeholder(T, size_t N)(
      const(char)* name,
      long[N] dims...) scope return
  {
    TF_OperationDescription* desc = TF_NewOperation(this.ptr, "Placeholder", name);
    TF_SetAttrType(desc, "dtype", tfType!T);
    static if (N != 0)
    {
      TF_SetAttrShape(desc, "shape", dims.ptr, dims.length);
    }
    TF_Operation* op = TF_FinishOperation(desc, this.status);
    assertStatus(this.status);
    assert(op);
    return Operation(op, this.base);
  }

  /// ditto.
  Operation placeholder(T, size_t N)(long[N] dims ...)
  {
    return placeholder!T("", dims);
  }

  /// Creates a constant in this graph.
  @trusted
  Operation constant(S)(S x, const(char)* name = "const")
  {
    import tfd.tensor : makeTF_Tensor;

    // TODO(karita) free TF_Tensor when op is freed?
    auto t = x.makeTF_Tensor;
    TF_OperationDescription* desc = TF_NewOperation(this.ptr, "Const", name);
    TF_SetAttrTensor(desc, "value", t, this.status);
    assertStatus(this.status);
    TF_SetAttrType(desc, "dtype", TF_TensorType(t));
    TF_Operation* op = TF_FinishOperation(desc, this.status);
    assertStatus(this.status);
    assert(op !is null);
    return Operation(op, this);
  }

  /// Creates a Session in this graph.
  @nogc nothrow @trusted
  Session session()
  {
    return Session(this.ptr);
  }
}

/// Creates a new reference-counted Graph object.
@nogc nothrow @trusted
Graph newGraph()
{
  import mir.rc.slim_ptr : createSlimRC;
  return Graph(createSlimRC!GraphOwner(TF_NewGraph(), TF_NewStatus()));
}

/// Export/import graph.
version (tfd_test)
nothrow
unittest
{
  import tfd.tensor;

  TF_Buffer* buffer;
  scope (exit) TF_DeleteBuffer(buffer);
  {
    auto graph = newGraph;
    with (graph)
    {
      auto a = placeholder!int("a");
      assert(TF_GraphOperationByName(graph, "a"));
      auto b = constant(3, "b");
      assert(TF_GraphOperationByName(graph, "b"));
      // TODO(karita): provide name "add", identity?
      auto add = a + b;
      assert(TF_GraphOperationByName(graph, "add"));
    }
    buffer = graph.serialize;
    // for coverage
    graph.write("tmp.bin");
  }
  with (newGraph) {
    // Import from the GraphDef (protobuf)
    deserialize(buffer.data[0 .. buffer.length]);
    auto a = getOperationByName("a");
    auto add = getOperationByName("add");
    const t = session.run([add], [a: 1.tensor])[0].tensor;
    assert(t.scalar!int == 1 + 3);
  }
}
