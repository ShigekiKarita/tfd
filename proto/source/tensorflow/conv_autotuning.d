// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: tensorflow/core/protobuf/conv_autotuning.proto

module tensorflow.conv_autotuning;

import google.protobuf;
import stream_executor.dnn.dnn;

enum protocVersion = 3012004;

class ConvolutionProto
{
    @Proto(1) ConvolutionKind kind = protoDefaultValue!(ConvolutionKind);
    @Proto(2) TensorDescriptorProto input = protoDefaultValue!(TensorDescriptorProto);
    @Proto(3) TensorDescriptorProto filter = protoDefaultValue!(TensorDescriptorProto);
    @Proto(4) TensorDescriptorProto output = protoDefaultValue!(TensorDescriptorProto);
    @Proto(5) ConvolutionDescriptorProto convDesc = protoDefaultValue!(ConvolutionDescriptorProto);
    @Proto(6) double convScale = protoDefaultValue!(double);
    @Proto(7) double sideValueScale = protoDefaultValue!(double);
    @Proto(8) ActivationMode activation = protoDefaultValue!(ActivationMode);
    @Proto(9) long inputAddress = protoDefaultValue!(long);
    @Proto(10) long filterAddress = protoDefaultValue!(long);
    @Proto(11) long outputAddress = protoDefaultValue!(long);
    @Proto(12) long biasAddress = protoDefaultValue!(long);
    @Proto(13) long sideInputAddress = protoDefaultValue!(long);
}
