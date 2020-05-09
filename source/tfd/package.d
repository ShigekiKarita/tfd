module tfd;

public import tfd.graph;
public import tfd.session;
public import tfd.tensor;


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
