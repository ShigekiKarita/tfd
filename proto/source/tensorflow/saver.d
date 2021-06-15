// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: tensorflow/core/protobuf/saver.proto

module tensorflow.saver;

import google.protobuf;

enum protocVersion = 3012004;

class SaverDef
{
    @Proto(1) string filenameTensorName = protoDefaultValue!(string);
    @Proto(2) string saveTensorName = protoDefaultValue!(string);
    @Proto(3) string restoreOpName = protoDefaultValue!(string);
    @Proto(4) int maxToKeep = protoDefaultValue!(int);
    @Proto(5) bool sharded = protoDefaultValue!(bool);
    @Proto(6) float keepCheckpointEveryNHours = protoDefaultValue!(float);
    @Proto(7) CheckpointFormatVersion version_ = protoDefaultValue!(CheckpointFormatVersion);

    enum CheckpointFormatVersion
    {
        LEGACY = 0,
        V1 = 1,
        V2 = 2,
    }
}
