// -*- c-basic-style: google, c-basic-offset: 2 -*-

/** D wrapper for Protobuf-C + dpp created objects.
    https://github.com/protobuf-c/protobuf-c
    https://github.com/atilaneves/dpp
*/
module tfd.protobuf;


struct ProtobufCMessageDescriptor;

struct ProtobufCMessageUnknownField;

struct ProtobufCMessage
{
  const(ProtobufCMessageDescriptor)* descriptor;
  uint n_unknown_fields;
  ProtobufCMessageUnknownField* unknown_fields;
}

bool isMessage(T)() {
  static if (__traits(compiles, T.init.base))
    // name-based comparison to avoid module name mangling
    return typeof(T.init.base).stringof == "ProtobufCMessage";
  else
    return false;
}

mixin template OpDispatchMixin(alias base)
{
  auto opDispatch(string name)()
  {
    import std.string : fromStringz;
    import std.traits : hasMember, isPointer, PointerTarget;

    auto child = __traits(getMember, base, name);
    alias Child = typeof(child);
    alias Base = typeof(base);

    // nested message
    static if (isPointer!Child && isMessage!Child)
    {
      alias Ret = Message!(PointerTarget!Child);
      return child ? Ret(*child) : Ret();
    }
    // array
    else static if (isPointer!Child && hasMember!(Base, "n_" ~ name))
    {
      auto n = __traits(getMember, base, "n_" ~ name);
      alias Elem = typeof(*Child.init);

      // nested message array
      static if (isPointer!Elem && isMessage!Elem)
      {
        alias Ret = Message!(PointerTarget!Elem);
        auto ret = new Ret[n];
        foreach (i, c; child[0 .. n])
        {
          if (c)
          {
            ret[i] =  Ret(*c);
          }
        }
        return ret;
      }
      // non-nested message array
      else
      {
        return child[0 .. n];
      }
    }
    // string
    else static if (__traits(compiles, child.fromStringz))
    {
      return child.fromStringz;
    }
    else
    {
      return child;
    }
  }
}

struct Message(Base)
{
  Base base;
  alias base this;

  mixin OpDispatchMixin!base;

  string toString()
  {
      import tensorflow.op_def_pb : Tensorflow__TensorProto, Tensorflow__AttrValue;
    static if (is(Base == Tensorflow__TensorProto) || is(Base == Tensorflow__AttrValue)) {
      return Base.stringof;
    }
    else return toStringImpl!(Base)(this.base);
  }
}

string toStringImpl(Base)(Base base) if (isMessage!Base)
{
  import std.conv : text;
  import std.string : startsWith;
  import std.traits : isPointer, isSomeString, PointerTarget;

  auto ret = Base.stringof ~ " {";
  static foreach (name; __traits(allMembers, Base))
  {
    // static foreach reuse the scope
    {
      // alias BaseChild = typeof(__traits(getMember, Base.init, name));
      static if (
          name == "base" ||
          name[0] == '_'
          //is(BaseChild == union)
                 )
      {
        // TODO(karita): support union value
      }
      else
      {
        auto child = Message!Base(base).opDispatch!name;
        alias Child = typeof(child);

        ret ~= name ~ ": ";
        scope (exit) ret ~= ", ";
        static if (is(Child : Message!T, T))
        {
          ret ~= child.toString;
        }
        else
        {
          static if (isSomeString!Child)
          {
            ret ~= "\"";
            scope (exit) ret ~= "\"";
          }
          ret ~= child.text;
        }
      }
    }
  }
  // trim last ", "
  return (ret[$-1 .. $] ==  " " ? ret[0 .. $-2] : ret) ~ "}";
}


/// protobuf-c message wrapper
unittest
{
  import core.stdc.config : c_ulong;

  // protobuf-c + dpp generates structs like these
  struct Child
  {
    ProtobufCMessage base;
    char* name;
  }

  struct Sample
  {
    ProtobufCMessage base;
    c_ulong n_farray;
    float* farray;
    char* name;
    Child* child;
    c_ulong n_children;
    Child** children;
  }

  // static tests
  static assert(isMessage!Child);
  static assert(isMessage!Sample);
  static assert(!isMessage!float);

  // example objects
  Child child = { name: cast(char*) "child" };
  Sample base = { n_farray: 2,
                  farray: [0.1f, 0.2f],
                  name: cast(char*) "foo\0",
                  child: &child,
                  n_children: 2,
                  children: [&child, &child]
  };

  // D friendly wrapper
  auto s = Message!Sample(base);

  import std.stdio;
  writeln(Message!Sample());
  writeln(Message!Sample(s));

  // basic type access
  assert(s.n_farray == 2);
  // string conversion
  assert(s.name == "foo");
  // array conversion
  assert(s.farray == [0.1f, 0.2f]);
  // nested message conversion
  assert(s.child.name == "child");
  // pretty print for debugging
  assert(s.toString ==
         `Sample {n_farray: 2, farray: [0.1, 0.2], name: "foo", `
         ~ `child: Child {name: "child"}, n_children: 2, `
         ~ `children: [Child {name: "child"}, Child {name: "child"}]}`);
}

/// test with tf proto
unittest
{
  import tensorflow.op_def_pb;
  import std.stdio;

  writeln(Message!Tensorflow__OpDef().toString);
  static assert(isMessage!Tensorflow__OpDef);
  static assert(isMessage!Tensorflow__OpDef__ArgDef);
  static assert(isMessage!Tensorflow__OpDef__AttrDef);
}


/// Prints all TF ops using toString (debugging)
void printAllTFOps()
{
    import tensorflow.c_api;
    import tensorflow.op_def_pb;

    alias OpDef = Message!Tensorflow__OpDef;

    import std.stdio;

    auto buf = TF_GetAllOpList();
    scope (exit) TF_DeleteBuffer(buf);
    auto opList = tensorflow__op_list__unpack(null, buf.length, cast(const(ubyte)*) buf.data);
    assert(opList, "unpack failed");

    auto ops = opList.op[0 .. opList.n_op];
    foreach (i, rawOp; ops)
    {
        auto op = OpDef(*rawOp);
        writefln("\n%s\n", op);
    }
}

