import tensorflow.compat.v1 as tf

with tf.Session() as sess:
  a = tf.placeholder(tf.int32, (), "a")
  b = tf.constant(3)
  c = tf.identity(a + b, "add")
  tf.io.write_graph(sess.graph_def, ".", "add-py.bin", as_text=False)
