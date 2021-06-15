// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: tensorflow/core/protobuf/meta_graph.proto

module tensorflow.meta_graph;

import google.protobuf;
import google.protobuf.any;
import tensorflow.graph;
import tensorflow.op_def;
import tensorflow.tensor_shape;
import tensorflow.types;
import tensorflow.saved_object_graph;
import tensorflow.saver;
import tensorflow.struct_;

enum protocVersion = 3012004;

class MetaGraphDef
{
    @Proto(1) MetaGraphDef.MetaInfoDef metaInfoDef = protoDefaultValue!(MetaGraphDef.MetaInfoDef);
    @Proto(2) GraphDef graphDef = protoDefaultValue!(GraphDef);
    @Proto(3) SaverDef saverDef = protoDefaultValue!(SaverDef);
    @Proto(4) CollectionDef[string] collectionDef = protoDefaultValue!(CollectionDef[string]);
    @Proto(5) SignatureDef[string] signatureDef = protoDefaultValue!(SignatureDef[string]);
    @Proto(6) AssetFileDef[] assetFileDef = protoDefaultValue!(AssetFileDef[]);
    @Proto(7) SavedObjectGraph objectGraphDef = protoDefaultValue!(SavedObjectGraph);

    static class MetaInfoDef
    {
        @Proto(1) string metaGraphVersion = protoDefaultValue!(string);
        @Proto(2) OpList strippedOpList = protoDefaultValue!(OpList);
        @Proto(3) Any anyInfo = protoDefaultValue!(Any);
        @Proto(4) string[] tags = protoDefaultValue!(string[]);
        @Proto(5) string tensorflowVersion = protoDefaultValue!(string);
        @Proto(6) string tensorflowGitVersion = protoDefaultValue!(string);
        @Proto(7) bool strippedDefaultAttrs = protoDefaultValue!(bool);
    }
}

class CollectionDef
{
    enum KindCase
    {
        kindNotSet = 0,
        nodeList = 1,
        bytesList = 2,
        int64List = 3,
        floatList = 4,
        anyList = 5,
    }
    KindCase _kindCase = KindCase.kindNotSet;
    @property KindCase kindCase() { return _kindCase; }
    void clearKind() { _kindCase = KindCase.kindNotSet; }
    @Oneof("_kindCase") union
    {
        @Proto(1) CollectionDef.NodeList _nodeList = protoDefaultValue!(CollectionDef.NodeList); mixin(oneofAccessors!_nodeList);
        @Proto(2) CollectionDef.BytesList _bytesList; mixin(oneofAccessors!_bytesList);
        @Proto(3) CollectionDef.Int64List _int64List; mixin(oneofAccessors!_int64List);
        @Proto(4) CollectionDef.FloatList _floatList; mixin(oneofAccessors!_floatList);
        @Proto(5) CollectionDef.AnyList _anyList; mixin(oneofAccessors!_anyList);
    }

    static class NodeList
    {
        @Proto(1) string[] value = protoDefaultValue!(string[]);
    }

    static class BytesList
    {
        @Proto(1) bytes[] value = protoDefaultValue!(bytes[]);
    }

    static class Int64List
    {
        @Proto(1, Wire.none, Yes.packed) long[] value = protoDefaultValue!(long[]);
    }

    static class FloatList
    {
        @Proto(1, Wire.none, Yes.packed) float[] value = protoDefaultValue!(float[]);
    }

    static class AnyList
    {
        @Proto(1) Any[] value = protoDefaultValue!(Any[]);
    }
}

class TensorInfo
{
    enum EncodingCase
    {
        encodingNotSet = 0,
        name = 1,
        cooSparse = 4,
        compositeTensor = 5,
    }
    EncodingCase _encodingCase = EncodingCase.encodingNotSet;
    @property EncodingCase encodingCase() { return _encodingCase; }
    void clearEncoding() { _encodingCase = EncodingCase.encodingNotSet; }
    @Oneof("_encodingCase") union
    {
        @Proto(1) string _name = protoDefaultValue!(string); mixin(oneofAccessors!_name);
        @Proto(4) TensorInfo.CooSparse _cooSparse; mixin(oneofAccessors!_cooSparse);
        @Proto(5) TensorInfo.CompositeTensor _compositeTensor; mixin(oneofAccessors!_compositeTensor);
    }
    @Proto(2) DataType dtype = protoDefaultValue!(DataType);
    @Proto(3) TensorShapeProto tensorShape = protoDefaultValue!(TensorShapeProto);

    static class CooSparse
    {
        @Proto(1) string valuesTensorName = protoDefaultValue!(string);
        @Proto(2) string indicesTensorName = protoDefaultValue!(string);
        @Proto(3) string denseShapeTensorName = protoDefaultValue!(string);
    }

    static class CompositeTensor
    {
        @Proto(1) TypeSpecProto typeSpec = protoDefaultValue!(TypeSpecProto);
        @Proto(2) TensorInfo[] components = protoDefaultValue!(TensorInfo[]);
    }
}

class SignatureDef
{
    @Proto(1) TensorInfo[string] inputs = protoDefaultValue!(TensorInfo[string]);
    @Proto(2) TensorInfo[string] outputs = protoDefaultValue!(TensorInfo[string]);
    @Proto(3) string methodName = protoDefaultValue!(string);
}

class AssetFileDef
{
    @Proto(1) TensorInfo tensorInfo = protoDefaultValue!(TensorInfo);
    @Proto(2) string filename = protoDefaultValue!(string);
}
