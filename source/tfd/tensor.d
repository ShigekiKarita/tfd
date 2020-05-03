/// TF_Tensor wrapper.
module tfd.tensor;

import std.typecons : tuple;

import mir.rc.array : RCArray;
import mir.rc.ptr : createRC, RCPtr;

import tensorflow.c_api;

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

/// Creates a tensor with dtype of T with values to copy.
TF_Tensor* makeTensor(T, size_t N)(long[N] dims, const(T)* values) 
{
  import core.stdc.string : memcpy;

  TF_Tensor* t = empty!T(dims);
  if (values) 
  {
    memcpy(TF_TensorData(t), values, T.sizeof * TF_TensorElementCount(t));
  }
  return t;
}


/// Creates a tensor with a given scalar.
TF_Tensor* makeTensor(T)(const(T) scalar)
{
  long[0] dims;
  return makeTensor!(T, 0)(dims, &scalar);
}

/// Make a scalar tensor;
unittest
{
  auto t = makeTensor(0);
  assert(TF_TensorType(t) == TF_INT32);
}

/// Tensor freed by dtor (RAII) with convinient methods.
struct TensorOwner
{
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

  /// Return tensor dimensions i.e., shape
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
}

alias RCTensor = RCPtr!TensorOwner;

/// Allocates ref-counted (RC) Tensor.
@trusted
RCTensor makeRCTensor(Args ...)(Args args)
{
  import core.lifetime : forward;
  return createRC!TensorOwner(makeTensor(forward!args));
}

/// Make a scalar RCTensor.
@nogc nothrow @safe
unittest
{
  const RCTensor t = makeRCTensor(123);

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

/// Make a multi-dim RCTensor.
@nogc nothrow @safe
unittest
{
  const RCTensor t = createRC!TensorOwner(empty!double(1, 2, 3));

  // check content
  assert(t.ndim == 3);
  static immutable expectedShape = [1, 2, 3];
  assert(t.shape[] == expectedShape);
  assert(t.dataType == TF_DOUBLE);
}