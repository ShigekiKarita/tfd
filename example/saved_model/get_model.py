# https://www.tensorflow.org/guide/saved_model
import tensorflow as tf

pretrained_model = tf.keras.applications.MobileNetV2()
tf.saved_model.save(pretrained_model, "mobilenet_v2/1/")
