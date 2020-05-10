/// TF_Tensor wrapper.
module tfd.tensor;

import std.traits : isScalarType;
import std.typecons : tuple;

import mir.ndslice.slice : Slice, SliceKind;
import mir.rc.slim_ptr : createSlimRC, SlimRCPtr;

import tfd.c_api;
version (Windows) alias size_t = object.size_t;

import tfd.testing : assertStatus;

// TODO(karita): support all dtypes in TF

/// Meta data to store TF/D types.
struct TFDPair(_D, TF_DataType _tf) {
  /// tensorflow type
  enum tf = _tf;
  /// D type
  alias D = _D;
}

import std.meta : AliasSeq;
import std.complex : Complex;
import std.numeric : CustomFloat;

/// IEEE 754-2008 half: https://en.wikipedia.org/wiki/Half-precision_floating-point_format
alias half = CustomFloat!(10, 5);
/// bfloat16: https://en.wikipedia.org/wiki/Bfloat16_floating-point_format
alias bfloat16 = CustomFloat!(7, 8);

alias tfdTypePairList = AliasSeq!(
    TFDPair!(float, TF_FLOAT),
    TFDPair!(double, TF_DOUBLE),
    TFDPair!(int, TF_INT32),
    TFDPair!(ubyte, TF_UINT8),
    TFDPair!(short, TF_INT16),
    TFDPair!(byte, TF_INT8),

    // TODO(karita): specialize this for conversion.
    TFDPair!(string, TF_STRING),

    // NOTE: these two looks same
    TFDPair!(Complex!float, TF_COMPLEX64),
    TFDPair!(Complex!float, TF_COMPLEX),

    TFDPair!(long, TF_INT64),
    TFDPair!(bool, TF_BOOL),

    // TODO(karita)
    // TF_QINT8 = 11,
    // TF_QUINT8 = 12,
    // TF_QINT32 = 13,

    TFDPair!(bfloat16, TF_BFLOAT16),

    // TODO(karita)
    // TF_QINT16 = 15,
    // TF_QUINT16 = 16,

    TFDPair!(ushort, TF_UINT16),
    TFDPair!(Complex!double, TF_COMPLEX128),
    TFDPair!(half, TF_HALF),

    // TODO(karita): what is this?
    // TF_RESOURCE = 20,
    // TF_VARIANT = 21,

    TFDPair!(uint, TF_UINT32),
    TFDPair!(ulong, TF_UINT64),
);

static foreach (type; tfdTypePairList)
{
  enum tfType(T: type.D) = type.tf;
}


/// Creates an uninitialized tensor with dtype of T.
@trusted
TF_Tensor* empty(T, size_t N)(long[N] dims...)
{
  size_t num_values = 1;
  foreach (d; dims) {
    num_values *= d;
  }

  static if (N == 0)
  {
    const dimsPtr = null;
  }
  else
  {
    const dimsPtr = dims.ptr;
  }
  return TF_AllocateTensor(
      tfType!T, dimsPtr, N, T.sizeof * num_values);
}


/// Creates a tensor from a given range.
TF_Tensor* makeTF_Tensor(size_t N, SourceRange)(long[N] dims, SourceRange source)
{
  import std.algorithm.mutation : copy;
  import std.range.primitives : ElementType;

  alias T = ElementType!SourceRange;
  TF_Tensor* t = empty!T(dims);
  T[] target = (cast(T*) TF_TensorData(t))[0 .. TF_TensorElementCount(t)];
  copy(source, target);
  return t;
}

/// Creates a tensor from a given mir.ndslice.Slice
TF_Tensor* makeTF_Tensor(Iterator, size_t N, SliceKind kind)(Slice!(Iterator, N, kind) slice)
{
  import mir.ndslice.topology : flattened;
  long[N] shape;
  static foreach (i; 0 .. N)
  {
    shape[i] = slice.length!i;
  }
  return makeTF_Tensor(shape, slice.flattened);
}

///
unittest
{
  import mir.ndslice : iota, universal;

  auto slice = iota(2, 3);
  auto tensor = slice.makeTF_Tensor;
  scope (exit) TF_DeleteTensor(tensor);
}

/// Creates a tensor from a given scalar.
TF_Tensor* makeTF_Tensor(T)(T scalar) if (isScalarType!T)
{
  long[0] dims;
  return makeTF_Tensor(dims, (&scalar)[0 .. 1]);
}

///
@nogc nothrow
unittest
{
  auto t = makeTF_Tensor(0);
  scope (exit) TF_DeleteTensor(t);
  assert(TF_TensorType(t) == TF_INT32);
}

/// Tensor freed by dtor (RAII) with convinient methods.
struct TensorOwner
{
  import mir.ndslice.slice : Contiguous;
  import mir.rc.array : RCArray;

  /// Base pointer.
  TF_Tensor* ptr;
  alias ptr this;

  // Not copyable.
  @disable this(this);

  /// Dtor.
  @nogc nothrow @trusted
  ~this()
  {
    TF_DeleteTensor(ptr);
  }

  /// Return an array storing data.
  @nogc nothrow @trusted
  inout(T)[] payload(T)() inout
  {
    auto tp = cast(inout(T)*) TF_TensorData(this.ptr);
    return tp[0 .. this.elementCount];
  }

  /// Return the number of elements.
  @nogc nothrow @trusted
  long elementCount() const
  {
    return TF_TensorElementCount(this.ptr);
  }

  /// Return the number of dimentions.
  @nogc nothrow @trusted
  int ndim() const
  {
    return TF_NumDims(this.ptr);
  }

  /// Returns a tensor shape.
  @nogc nothrow @trusted
  RCArray!long shape() const
  {
    auto ret = RCArray!long(this.ndim);
    foreach (i; 0 .. this.ndim)
    {
      ret[i] = TF_Dim(this.ptr, i);
    }
    return ret;
  }

  /// Returns data type, i.e. element type enum identifier.
  @nogc nothrow @trusted
  TF_DataType dataType() const
  {
    return TF_TensorType(this.ptr);
  }

  /// Returns a tensor slice as same as a given slice with assertions.
  Slice!(T*, N, Contiguous)
  slicedAs(Iterator, size_t N, SliceKind kind, T = typeof(Iterator.init[0]))(
      Slice!(Iterator, N, kind) slice)
  {
    static foreach (i; 0 .. N)
    {
      assert(this.shape[i] == slice.length!i);
    }
    return cast(typeof(return)) this.sliced!(T, N);
  }

  /// Return a tensor slice with an element type T with assertions.
  Slice!(T*, N, Contiguous) sliced(T, size_t N)()
  {
    import mir.ndslice.slice : sliced;

    assert(this.ndim == N);

    size_t[N] lengths;
    static foreach (i; 0 .. N)
    {
      lengths[i] = this.shape[i];
    }
    return this.payload!T.sliced(lengths);
  }

  /// Returns a scalar if valid.
  T scalar(T)()
  {
    assert(this.ndim == 0);
    return this.payload!T[0];
  }
}

///
alias Tensor = SlimRCPtr!TensorOwner;

/// Allocates ref-counted (RC) Tensor.
/// TODO(karita): non-allocated (borrowed) version.
@trusted
Tensor tensor(Args ...)(Args args)
{
  import core.lifetime : forward;
  return createSlimRC!TensorOwner(makeTF_Tensor(forward!args));
}

/// Make a scalar RCTensor.
@nogc nothrow @safe
unittest
{
  const t = tensor(123);

  // check content
  assert(t.payload!int[0] == 123);
  assert(t.ndim == 0);
  assert(t.elementCount == 1);
  assert(t.shape.length == 0);
  assert(t.dataType == TF_INT32);

  // check RC
  assert(t._counter == 1);
  {
    const t1 = t;
    assert(t._counter == 2);
    assert(t1._counter == 2);
  }
  assert(t._counter == 1);
}

/// Make an empty multi-dim RCTensor.
@nogc nothrow @safe
unittest
{
  const t = createSlimRC!TensorOwner(empty!double(1, 2, 3));

  // check content
  assert(t.ndim == 3);
  static immutable expectedShape = [1, 2, 3];
  assert(t.shape[] == expectedShape);
  assert(t.dataType == TF_DOUBLE);
}

/// Make a Tensor from iota slice.
@nogc nothrow @safe
unittest
{
  import mir.ndslice : iota, sliced;

  auto s = iota(2, 3);
  auto t = s.tensor;
  auto st = t.slicedAs(s);
  assert(t.dataType == TF_INT64);
  assert(t.shape[] == s.shape);
  assert(st == s);
}
