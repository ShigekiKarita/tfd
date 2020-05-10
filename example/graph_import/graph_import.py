import tensorflow.compat.v1 as tf

with tf.Session() as sess:
  with open("add-d.bin", "rb") as f:
    graph_def = tf.GraphDef()
    graph_def.ParseFromString(f.read())

  tf.import_graph_def(graph_def)
  graph = tf.get_default_graph()
  for op in graph.get_operations():
    print(op.name)

  a = graph.get_tensor_by_name("import/a:0")
  add = graph.get_tensor_by_name("import/add:0")
  result = sess.run(add, {a: 1})
  print(result)
  assert(result == 4)
