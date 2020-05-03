/// TF_Tensor wrapper.
module tfd.tensor;

import tensorflow.c_api;

import tfd.testing : assertStatus;

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
