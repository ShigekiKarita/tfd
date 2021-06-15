module tfd.saved_model;

import tensorflow.config : ConfigProto;

/// Configuration information for a Session.
struct SessionOptions {
  /// The TensorFlow runtime to connect to.
  string target;
  /// Configuration options.
  ConfigProto config;
}

void Load(string path) {
}
