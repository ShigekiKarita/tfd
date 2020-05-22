/// pbtxt parser
module tfd.pbtxt;

import pegged.grammar;

mixin(grammar(`
PbTxt:
    Root   < Dict*

    Dict   <  identifier :'{' (Pair / Dict)* :'}'

    Pair   <  identifier :':' Value

    Value  <  String
            / Number
            / True
            / False
            / Enum

    Enum   <- identifier

    True   <- "true"
    False  <- "false"

    String <~ :doublequote Char* :doublequote
    Char   <~ backslash doublequote
            / backslash backslash
            / backslash [bfnrt]
            / (!doublequote .)

    Number <~ Sign? Integer "."? Integer? (("e" / "E") Sign? Integer)?
    Integer <~ digit+
    Sign <- "-" / "+"
`));


version (unittest)
enum exampleProto = `
op {
  name: "AddN"
  input_arg {
    name: "inputs"
    type_attr: "T"
    number_attr: "N"
  }
  output_arg {
    name: "sum"
    type_attr: "T"
  }
  attr {
    name: "N"
    type: "int"
    has_minimum: true
    minimum: 1
  }
  attr {
    name: "T"
    type: "type"
    allowed_values {
      list {
        type: DT_FLOAT
        type: DT_DOUBLE
        type: DT_INT32
        type: DT_UINT8
        type: DT_INT16
        type: DT_INT8
        type: DT_COMPLEX64
        type: DT_INT64
        type: DT_QINT8
        type: DT_QUINT8
        type: DT_QINT32
        type: DT_BFLOAT16
        type: DT_UINT16
        type: DT_COMPLEX128
        type: DT_HALF
        type: DT_UINT32
        type: DT_UINT64
        type: DT_VARIANT
      }
    }
  }
  is_aggregate: true
  is_commutative: true
}
op {
  name: "Identity"
  input_arg {
    name: "input"
    type_attr: "T"
  }
  output_arg {
    name: "output"
    type_attr: "T"
  }
  attr {
    name: "T"
    type: "type"
  }
}
`;


unittest
{
  auto tree = PbTxt(exampleProto);
  assert(tree.successful);

  auto root = tree.children[0];
  auto addN = root.children[0];
  assert(addN.name == "PbTxt.Dict");
  assert(addN.matches[0] == "op");
  assert(addN.children[0].matches == ["name", "AddN"]);

  auto identity = root.children[1];
  assert(identity.matches[0] == "op");
  assert(identity.children[0].matches == ["name", "Identity"]);
}
