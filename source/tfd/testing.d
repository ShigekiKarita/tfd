/// Testing module.
module tfd.testing;

import tensorflow.c_api;

/// Asserts TF_Status and shows message if failed.
@nogc nothrow @trusted
void assertStatus(TF_Status* s)
{
  import std.string : fromStringz;
  assert(TF_GetCode(s) == TF_OK, TF_Message(s).fromStringz);
}
