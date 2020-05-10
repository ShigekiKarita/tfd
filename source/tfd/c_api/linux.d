module tfd.c_api.linux;
version (linux):

        import core.stdc.config;
        import core.stdc.stdarg: va_list;
        static import core.simd;
        static import std.conv;

        struct Int128 { long lower; long upper; }
        struct UInt128 { ulong lower; ulong upper; }

        struct __locale_data { int dummy; }



alias _Bool = bool;
struct dpp {
    static struct Opaque(int N) {
        void[N] bytes;
    }

    static bool isEmpty(T)() {
        return T.tupleof.length == 0;
    }
    static struct Move(T) {
        T* ptr;
    }


    static auto move(T)(ref T value) {
        return Move!T(&value);
    }
    mixin template EnumD(string name, T, string prefix) if(is(T == enum)) {
        private static string _memberMixinStr(string member) {
            import std.conv: text;
            import std.array: replace;
            return text(` `, member.replace(prefix, ""), ` = `, T.stringof, `.`, member, `,`);
        }
        private static string _enumMixinStr() {
            import std.array: join;
            string[] ret;
            ret ~= "enum " ~ name ~ "{";
            static foreach(member; __traits(allMembers, T)) {
                ret ~= _memberMixinStr(member);
            }
            ret ~= "}";
            return ret.join("\n");
        }
        mixin(_enumMixinStr());
    }
}

extern(C)
{
    bool TF_TensorIsAligned(const(TF_Tensor)*) @nogc nothrow;
    c_ulong TF_StringEncodedSize(c_ulong) @nogc nothrow;
    c_ulong TF_StringDecode(const(char)*, c_ulong, const(char)**, c_ulong*, TF_Status*) @nogc nothrow;
    c_ulong TF_StringEncode(const(char)*, c_ulong, char*, c_ulong, TF_Status*) @nogc nothrow;
    void TF_TensorBitcastFrom(const(TF_Tensor)*, TF_DataType, TF_Tensor*, const(c_long)*, int, TF_Status*) @nogc nothrow;
    c_long TF_TensorElementCount(const(TF_Tensor)*) @nogc nothrow;
    void* TF_TensorData(const(TF_Tensor)*) @nogc nothrow;
    c_ulong TF_TensorByteSize(const(TF_Tensor)*) @nogc nothrow;
    c_long TF_Dim(const(TF_Tensor)*, int) @nogc nothrow;
    int TF_NumDims(const(TF_Tensor)*) @nogc nothrow;
    TF_DataType TF_TensorType(const(TF_Tensor)*) @nogc nothrow;
    void TF_DeleteTensor(TF_Tensor*) @nogc nothrow;
    TF_Tensor* TF_TensorMaybeMove(TF_Tensor*) @nogc nothrow;
    TF_Tensor* TF_AllocateTensor(TF_DataType, const(c_long)*, int, c_ulong) @nogc nothrow;
    TF_Tensor* TF_NewTensor(TF_DataType, const(c_long)*, int, void*, c_ulong, void function(void*, c_ulong, void*), void*) @nogc nothrow;
    struct TF_Tensor;
    const(char)* TF_Message(const(TF_Status)*) @nogc nothrow;
    TF_Code TF_GetCode(const(TF_Status)*) @nogc nothrow;
    void TF_SetStatus(TF_Status*, TF_Code, const(char)*) @nogc nothrow;
    void TF_DeleteStatus(TF_Status*) @nogc nothrow;
    TF_Status* TF_NewStatus() @nogc nothrow;
    enum TF_Code
    {
        TF_OK = 0,
        TF_CANCELLED = 1,
        TF_UNKNOWN = 2,
        TF_INVALID_ARGUMENT = 3,
        TF_DEADLINE_EXCEEDED = 4,
        TF_NOT_FOUND = 5,
        TF_ALREADY_EXISTS = 6,
        TF_PERMISSION_DENIED = 7,
        TF_UNAUTHENTICATED = 16,
        TF_RESOURCE_EXHAUSTED = 8,
        TF_FAILED_PRECONDITION = 9,
        TF_ABORTED = 10,
        TF_OUT_OF_RANGE = 11,
        TF_UNIMPLEMENTED = 12,
        TF_INTERNAL = 13,
        TF_UNAVAILABLE = 14,
        TF_DATA_LOSS = 15,
    }
    enum TF_OK = TF_Code.TF_OK;
    enum TF_CANCELLED = TF_Code.TF_CANCELLED;
    enum TF_UNKNOWN = TF_Code.TF_UNKNOWN;
    enum TF_INVALID_ARGUMENT = TF_Code.TF_INVALID_ARGUMENT;
    enum TF_DEADLINE_EXCEEDED = TF_Code.TF_DEADLINE_EXCEEDED;
    enum TF_NOT_FOUND = TF_Code.TF_NOT_FOUND;
    enum TF_ALREADY_EXISTS = TF_Code.TF_ALREADY_EXISTS;
    enum TF_PERMISSION_DENIED = TF_Code.TF_PERMISSION_DENIED;
    enum TF_UNAUTHENTICATED = TF_Code.TF_UNAUTHENTICATED;
    enum TF_RESOURCE_EXHAUSTED = TF_Code.TF_RESOURCE_EXHAUSTED;
    enum TF_FAILED_PRECONDITION = TF_Code.TF_FAILED_PRECONDITION;
    enum TF_ABORTED = TF_Code.TF_ABORTED;
    enum TF_OUT_OF_RANGE = TF_Code.TF_OUT_OF_RANGE;
    enum TF_UNIMPLEMENTED = TF_Code.TF_UNIMPLEMENTED;
    enum TF_INTERNAL = TF_Code.TF_INTERNAL;
    enum TF_UNAVAILABLE = TF_Code.TF_UNAVAILABLE;
    enum TF_DATA_LOSS = TF_Code.TF_DATA_LOSS;
    struct TF_Status;
    c_ulong TF_DataTypeSize(TF_DataType) @nogc nothrow;
    enum TF_DataType
    {
        TF_FLOAT = 1,
        TF_DOUBLE = 2,
        TF_INT32 = 3,
        TF_UINT8 = 4,
        TF_INT16 = 5,
        TF_INT8 = 6,
        TF_STRING = 7,
        TF_COMPLEX64 = 8,
        TF_COMPLEX = 8,
        TF_INT64 = 9,
        TF_BOOL = 10,
        TF_QINT8 = 11,
        TF_QUINT8 = 12,
        TF_QINT32 = 13,
        TF_BFLOAT16 = 14,
        TF_QINT16 = 15,
        TF_QUINT16 = 16,
        TF_UINT16 = 17,
        TF_COMPLEX128 = 18,
        TF_HALF = 19,
        TF_RESOURCE = 20,
        TF_VARIANT = 21,
        TF_UINT32 = 22,
        TF_UINT64 = 23,
    }
    enum TF_FLOAT = TF_DataType.TF_FLOAT;
    enum TF_DOUBLE = TF_DataType.TF_DOUBLE;
    enum TF_INT32 = TF_DataType.TF_INT32;
    enum TF_UINT8 = TF_DataType.TF_UINT8;
    enum TF_INT16 = TF_DataType.TF_INT16;
    enum TF_INT8 = TF_DataType.TF_INT8;
    enum TF_STRING = TF_DataType.TF_STRING;
    enum TF_COMPLEX64 = TF_DataType.TF_COMPLEX64;
    enum TF_COMPLEX = TF_DataType.TF_COMPLEX;
    enum TF_INT64 = TF_DataType.TF_INT64;
    enum TF_BOOL = TF_DataType.TF_BOOL;
    enum TF_QINT8 = TF_DataType.TF_QINT8;
    enum TF_QUINT8 = TF_DataType.TF_QUINT8;
    enum TF_QINT32 = TF_DataType.TF_QINT32;
    enum TF_BFLOAT16 = TF_DataType.TF_BFLOAT16;
    enum TF_QINT16 = TF_DataType.TF_QINT16;
    enum TF_QUINT16 = TF_DataType.TF_QUINT16;
    enum TF_UINT16 = TF_DataType.TF_UINT16;
    enum TF_COMPLEX128 = TF_DataType.TF_COMPLEX128;
    enum TF_HALF = TF_DataType.TF_HALF;
    enum TF_RESOURCE = TF_DataType.TF_RESOURCE;
    enum TF_VARIANT = TF_DataType.TF_VARIANT;
    enum TF_UINT32 = TF_DataType.TF_UINT32;
    enum TF_UINT64 = TF_DataType.TF_UINT64;
    enum TF_AttrType
    {
        TF_ATTR_STRING = 0,
        TF_ATTR_INT = 1,
        TF_ATTR_FLOAT = 2,
        TF_ATTR_BOOL = 3,
        TF_ATTR_TYPE = 4,
        TF_ATTR_SHAPE = 5,
        TF_ATTR_TENSOR = 6,
        TF_ATTR_PLACEHOLDER = 7,
        TF_ATTR_FUNC = 8,
    }
    enum TF_ATTR_STRING = TF_AttrType.TF_ATTR_STRING;
    enum TF_ATTR_INT = TF_AttrType.TF_ATTR_INT;
    enum TF_ATTR_FLOAT = TF_AttrType.TF_ATTR_FLOAT;
    enum TF_ATTR_BOOL = TF_AttrType.TF_ATTR_BOOL;
    enum TF_ATTR_TYPE = TF_AttrType.TF_ATTR_TYPE;
    enum TF_ATTR_SHAPE = TF_AttrType.TF_ATTR_SHAPE;
    enum TF_ATTR_TENSOR = TF_AttrType.TF_ATTR_TENSOR;
    enum TF_ATTR_PLACEHOLDER = TF_AttrType.TF_ATTR_PLACEHOLDER;
    enum TF_ATTR_FUNC = TF_AttrType.TF_ATTR_FUNC;
    alias __sig_atomic_t = int;
    alias __socklen_t = uint;
    alias __intptr_t = c_long;
    alias __caddr_t = char*;
    alias __loff_t = c_long;
    alias __syscall_ulong_t = c_ulong;
    alias __syscall_slong_t = c_long;
    alias __ssize_t = c_long;
    alias __fsword_t = c_long;
    alias __fsfilcnt64_t = c_ulong;
    alias __fsfilcnt_t = c_ulong;
    alias __fsblkcnt64_t = c_ulong;
    alias __fsblkcnt_t = c_ulong;
    alias __blkcnt64_t = c_long;
    alias __blkcnt_t = c_long;
    alias __blksize_t = c_long;
    alias __timer_t = void*;
    alias __clockid_t = int;
    alias __key_t = int;
    alias __daddr_t = int;
    alias __suseconds_t = c_long;
    alias __useconds_t = uint;
    alias __time_t = c_long;
    alias __id_t = uint;
    alias __rlim64_t = c_ulong;
    alias __rlim_t = c_ulong;
    alias __clock_t = c_long;
    struct __fsid_t
    {
        int[2] __val;
    }
    alias __pid_t = int;
    alias __off64_t = c_long;
    alias __off_t = c_long;
    alias __nlink_t = c_ulong;
    alias __mode_t = uint;
    alias __ino64_t = c_ulong;
    alias __ino_t = c_ulong;
    alias __gid_t = uint;
    alias __uid_t = uint;
    alias __dev_t = c_ulong;
    alias __uintmax_t = c_ulong;
    alias __intmax_t = c_long;
    alias __u_quad_t = c_ulong;
    alias __quad_t = c_long;
    alias __uint64_t = c_ulong;
    alias __int64_t = c_long;
    alias __uint32_t = uint;
    alias __int32_t = int;
    alias __uint16_t = ushort;
    alias __int16_t = short;
    alias __uint8_t = ubyte;
    alias __int8_t = byte;
    alias __u_long = c_ulong;
    alias __u_int = uint;
    alias __u_short = ushort;
    alias __u_char = ubyte;
    alias uint64_t = ulong;
    alias uint32_t = uint;
    alias uint16_t = ushort;
    alias uint8_t = ubyte;
    alias int64_t = c_long;
    alias int32_t = int;
    alias int16_t = short;
    alias int8_t = byte;
    alias uintmax_t = c_ulong;
    alias intmax_t = c_long;
    alias uintptr_t = c_ulong;
    alias intptr_t = c_long;
    alias uint_fast64_t = c_ulong;
    alias uint_fast32_t = c_ulong;
    alias uint_fast16_t = c_ulong;
    alias uint_fast8_t = ubyte;
    alias int_fast64_t = c_long;
    alias int_fast32_t = c_long;
    alias int_fast16_t = c_long;
    alias int_fast8_t = byte;
    alias uint_least64_t = c_ulong;
    alias uint_least32_t = uint;
    alias uint_least16_t = ushort;
    alias uint_least8_t = ubyte;
    alias int_least64_t = c_long;
    alias int_least32_t = int;
    alias int_least16_t = short;
    alias int_least8_t = byte;
    const(char)* TF_Version() @nogc nothrow;
    struct TF_Buffer
    {
        const(void)* data;
        c_ulong length;
        void function(void*, c_ulong) data_deallocator;
    }
    TF_Buffer* TF_NewBufferFromString(const(void)*, c_ulong) @nogc nothrow;
    TF_Buffer* TF_NewBuffer() @nogc nothrow;
    void TF_DeleteBuffer(TF_Buffer*) @nogc nothrow;
    TF_Buffer TF_GetBuffer(TF_Buffer*) @nogc nothrow;
    struct TF_SessionOptions;
    TF_SessionOptions* TF_NewSessionOptions() @nogc nothrow;
    void TF_SetTarget(TF_SessionOptions*, const(char)*) @nogc nothrow;
    void TF_SetConfig(TF_SessionOptions*, const(void)*, c_ulong, TF_Status*) @nogc nothrow;
    void TF_DeleteSessionOptions(TF_SessionOptions*) @nogc nothrow;
    struct TF_Graph;
    TF_Graph* TF_NewGraph() @nogc nothrow;
    void TF_DeleteGraph(TF_Graph*) @nogc nothrow;
    struct TF_OperationDescription;
    struct TF_Operation;
    struct TF_Input
    {
        TF_Operation* oper;
        int index;
    }
    struct TF_Output
    {
        TF_Operation* oper;
        int index;
    }
    struct TF_Function;
    struct TF_FunctionOptions;
    void TF_GraphSetTensorShape(TF_Graph*, TF_Output, const(c_long)*, const(int), TF_Status*) @nogc nothrow;
    int TF_GraphGetTensorNumDims(TF_Graph*, TF_Output, TF_Status*) @nogc nothrow;
    void TF_GraphGetTensorShape(TF_Graph*, TF_Output, c_long*, int, TF_Status*) @nogc nothrow;
    TF_OperationDescription* TF_NewOperation(TF_Graph*, const(char)*, const(char)*) @nogc nothrow;
    void TF_SetDevice(TF_OperationDescription*, const(char)*) @nogc nothrow;
    void TF_AddInput(TF_OperationDescription*, TF_Output) @nogc nothrow;
    void TF_AddInputList(TF_OperationDescription*, const(TF_Output)*, int) @nogc nothrow;
    void TF_AddControlInput(TF_OperationDescription*, TF_Operation*) @nogc nothrow;
    void TF_ColocateWith(TF_OperationDescription*, TF_Operation*) @nogc nothrow;
    void TF_SetAttrString(TF_OperationDescription*, const(char)*, const(void)*, c_ulong) @nogc nothrow;
    void TF_SetAttrStringList(TF_OperationDescription*, const(char)*, const(const(void)*)*, const(c_ulong)*, int) @nogc nothrow;
    void TF_SetAttrInt(TF_OperationDescription*, const(char)*, c_long) @nogc nothrow;
    void TF_SetAttrIntList(TF_OperationDescription*, const(char)*, const(c_long)*, int) @nogc nothrow;
    void TF_SetAttrFloat(TF_OperationDescription*, const(char)*, float) @nogc nothrow;
    void TF_SetAttrFloatList(TF_OperationDescription*, const(char)*, const(float)*, int) @nogc nothrow;
    void TF_SetAttrBool(TF_OperationDescription*, const(char)*, ubyte) @nogc nothrow;
    void TF_SetAttrBoolList(TF_OperationDescription*, const(char)*, const(ubyte)*, int) @nogc nothrow;
    void TF_SetAttrType(TF_OperationDescription*, const(char)*, TF_DataType) @nogc nothrow;
    void TF_SetAttrTypeList(TF_OperationDescription*, const(char)*, const(TF_DataType)*, int) @nogc nothrow;
    void TF_SetAttrPlaceholder(TF_OperationDescription*, const(char)*, const(char)*) @nogc nothrow;
    void TF_SetAttrFuncName(TF_OperationDescription*, const(char)*, const(char)*, c_ulong) @nogc nothrow;
    void TF_SetAttrShape(TF_OperationDescription*, const(char)*, const(c_long)*, int) @nogc nothrow;
    void TF_SetAttrShapeList(TF_OperationDescription*, const(char)*, const(const(c_long)*)*, const(int)*, int) @nogc nothrow;
    void TF_SetAttrTensorShapeProto(TF_OperationDescription*, const(char)*, const(void)*, c_ulong, TF_Status*) @nogc nothrow;
    void TF_SetAttrTensorShapeProtoList(TF_OperationDescription*, const(char)*, const(const(void)*)*, const(c_ulong)*, int, TF_Status*) @nogc nothrow;
    void TF_SetAttrTensor(TF_OperationDescription*, const(char)*, TF_Tensor*, TF_Status*) @nogc nothrow;
    void TF_SetAttrTensorList(TF_OperationDescription*, const(char)*, TF_Tensor**, int, TF_Status*) @nogc nothrow;
    void TF_SetAttrValueProto(TF_OperationDescription*, const(char)*, const(void)*, c_ulong, TF_Status*) @nogc nothrow;
    TF_Operation* TF_FinishOperation(TF_OperationDescription*, TF_Status*) @nogc nothrow;
    const(char)* TF_OperationName(TF_Operation*) @nogc nothrow;
    const(char)* TF_OperationOpType(TF_Operation*) @nogc nothrow;
    const(char)* TF_OperationDevice(TF_Operation*) @nogc nothrow;
    int TF_OperationNumOutputs(TF_Operation*) @nogc nothrow;
    TF_DataType TF_OperationOutputType(TF_Output) @nogc nothrow;
    int TF_OperationOutputListLength(TF_Operation*, const(char)*, TF_Status*) @nogc nothrow;
    int TF_OperationNumInputs(TF_Operation*) @nogc nothrow;
    TF_DataType TF_OperationInputType(TF_Input) @nogc nothrow;
    int TF_OperationInputListLength(TF_Operation*, const(char)*, TF_Status*) @nogc nothrow;
    TF_Output TF_OperationInput(TF_Input) @nogc nothrow;
    int TF_OperationOutputNumConsumers(TF_Output) @nogc nothrow;
    int TF_OperationOutputConsumers(TF_Output, TF_Input*, int) @nogc nothrow;
    int TF_OperationNumControlInputs(TF_Operation*) @nogc nothrow;
    int TF_OperationGetControlInputs(TF_Operation*, TF_Operation**, int) @nogc nothrow;
    int TF_OperationNumControlOutputs(TF_Operation*) @nogc nothrow;
    int TF_OperationGetControlOutputs(TF_Operation*, TF_Operation**, int) @nogc nothrow;
    struct TF_AttrMetadata
    {
        ubyte is_list;
        c_long list_size;
        TF_AttrType type;
        c_long total_size;
    }
    TF_AttrMetadata TF_OperationGetAttrMetadata(TF_Operation*, const(char)*, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrString(TF_Operation*, const(char)*, void*, c_ulong, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrStringList(TF_Operation*, const(char)*, void**, c_ulong*, int, void*, c_ulong, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrInt(TF_Operation*, const(char)*, c_long*, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrIntList(TF_Operation*, const(char)*, c_long*, int, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrFloat(TF_Operation*, const(char)*, float*, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrFloatList(TF_Operation*, const(char)*, float*, int, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrBool(TF_Operation*, const(char)*, ubyte*, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrBoolList(TF_Operation*, const(char)*, ubyte*, int, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrType(TF_Operation*, const(char)*, TF_DataType*, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrTypeList(TF_Operation*, const(char)*, TF_DataType*, int, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrShape(TF_Operation*, const(char)*, c_long*, int, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrShapeList(TF_Operation*, const(char)*, c_long**, int*, int, c_long*, int, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrTensorShapeProto(TF_Operation*, const(char)*, TF_Buffer*, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrTensorShapeProtoList(TF_Operation*, const(char)*, TF_Buffer**, int, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrTensor(TF_Operation*, const(char)*, TF_Tensor**, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrTensorList(TF_Operation*, const(char)*, TF_Tensor**, int, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrValueProto(TF_Operation*, const(char)*, TF_Buffer*, TF_Status*) @nogc nothrow;
    TF_Operation* TF_GraphOperationByName(TF_Graph*, const(char)*) @nogc nothrow;
    TF_Operation* TF_GraphNextOperation(TF_Graph*, c_ulong*) @nogc nothrow;
    void TF_GraphToGraphDef(TF_Graph*, TF_Buffer*, TF_Status*) @nogc nothrow;
    void TF_GraphGetOpDef(TF_Graph*, const(char)*, TF_Buffer*, TF_Status*) @nogc nothrow;
    void TF_GraphVersions(TF_Graph*, TF_Buffer*, TF_Status*) @nogc nothrow;
    struct TF_ImportGraphDefOptions;
    TF_ImportGraphDefOptions* TF_NewImportGraphDefOptions() @nogc nothrow;
    void TF_DeleteImportGraphDefOptions(TF_ImportGraphDefOptions*) @nogc nothrow;
    void TF_ImportGraphDefOptionsSetPrefix(TF_ImportGraphDefOptions*, const(char)*) @nogc nothrow;
    void TF_ImportGraphDefOptionsSetDefaultDevice(TF_ImportGraphDefOptions*, const(char)*) @nogc nothrow;
    void TF_ImportGraphDefOptionsSetUniquifyNames(TF_ImportGraphDefOptions*, ubyte) @nogc nothrow;
    void TF_ImportGraphDefOptionsSetUniquifyPrefix(TF_ImportGraphDefOptions*, ubyte) @nogc nothrow;
    void TF_ImportGraphDefOptionsAddInputMapping(TF_ImportGraphDefOptions*, const(char)*, int, TF_Output) @nogc nothrow;
    void TF_ImportGraphDefOptionsRemapControlDependency(TF_ImportGraphDefOptions*, const(char)*, TF_Operation*) @nogc nothrow;
    void TF_ImportGraphDefOptionsAddControlDependency(TF_ImportGraphDefOptions*, TF_Operation*) @nogc nothrow;
    void TF_ImportGraphDefOptionsAddReturnOutput(TF_ImportGraphDefOptions*, const(char)*, int) @nogc nothrow;
    int TF_ImportGraphDefOptionsNumReturnOutputs(const(TF_ImportGraphDefOptions)*) @nogc nothrow;
    void TF_ImportGraphDefOptionsAddReturnOperation(TF_ImportGraphDefOptions*, const(char)*) @nogc nothrow;
    int TF_ImportGraphDefOptionsNumReturnOperations(const(TF_ImportGraphDefOptions)*) @nogc nothrow;
    struct TF_ImportGraphDefResults;
    void TF_ImportGraphDefResultsReturnOutputs(TF_ImportGraphDefResults*, int*, TF_Output**) @nogc nothrow;
    void TF_ImportGraphDefResultsReturnOperations(TF_ImportGraphDefResults*, int*, TF_Operation***) @nogc nothrow;
    void TF_ImportGraphDefResultsMissingUnusedInputMappings(TF_ImportGraphDefResults*, int*, const(char)***, int**) @nogc nothrow;
    void TF_DeleteImportGraphDefResults(TF_ImportGraphDefResults*) @nogc nothrow;
    TF_ImportGraphDefResults* TF_GraphImportGraphDefWithResults(TF_Graph*, const(TF_Buffer)*, const(TF_ImportGraphDefOptions)*, TF_Status*) @nogc nothrow;
    void TF_GraphImportGraphDefWithReturnOutputs(TF_Graph*, const(TF_Buffer)*, const(TF_ImportGraphDefOptions)*, TF_Output*, int, TF_Status*) @nogc nothrow;
    void TF_GraphImportGraphDef(TF_Graph*, const(TF_Buffer)*, const(TF_ImportGraphDefOptions)*, TF_Status*) @nogc nothrow;
    void TF_GraphCopyFunction(TF_Graph*, const(TF_Function)*, const(TF_Function)*, TF_Status*) @nogc nothrow;
    int TF_GraphNumFunctions(TF_Graph*) @nogc nothrow;
    int TF_GraphGetFunctions(TF_Graph*, TF_Function**, int, TF_Status*) @nogc nothrow;
    void TF_OperationToNodeDef(TF_Operation*, TF_Buffer*, TF_Status*) @nogc nothrow;
    struct TF_WhileParams
    {
        const(int) ninputs;
        TF_Graph* cond_graph;
        const(const(TF_Output)*) cond_inputs;
        TF_Output cond_output;
        TF_Graph* body_graph;
        const(const(TF_Output)*) body_inputs;
        TF_Output* body_outputs;
        const(char)* name;
    }
    TF_WhileParams TF_NewWhile(TF_Graph*, TF_Output*, int, TF_Status*) @nogc nothrow;
    void TF_FinishWhile(const(TF_WhileParams)*, TF_Status*, TF_Output*) @nogc nothrow;
    void TF_AbortWhile(const(TF_WhileParams)*) @nogc nothrow;
    void TF_AddGradients(TF_Graph*, TF_Output*, int, TF_Output*, int, TF_Output*, TF_Status*, TF_Output*) @nogc nothrow;
    void TF_AddGradientsWithPrefix(TF_Graph*, const(char)*, TF_Output*, int, TF_Output*, int, TF_Output*, TF_Status*, TF_Output*) @nogc nothrow;
    TF_Function* TF_GraphToFunction(const(TF_Graph)*, const(char)*, ubyte, int, const(const(TF_Operation)*)*, int, const(TF_Output)*, int, const(TF_Output)*, const(const(char)*)*, const(TF_FunctionOptions)*, const(char)*, TF_Status*) @nogc nothrow;
    TF_Function* TF_GraphToFunctionWithControlOutputs(const(TF_Graph)*, const(char)*, ubyte, int, const(const(TF_Operation)*)*, int, const(TF_Output)*, int, const(TF_Output)*, const(const(char)*)*, int, const(const(TF_Operation)*)*, const(const(char)*)*, const(TF_FunctionOptions)*, const(char)*, TF_Status*) @nogc nothrow;
    const(char)* TF_FunctionName(TF_Function*) @nogc nothrow;
    void TF_FunctionToFunctionDef(TF_Function*, TF_Buffer*, TF_Status*) @nogc nothrow;
    TF_Function* TF_FunctionImportFunctionDef(const(void)*, c_ulong, TF_Status*) @nogc nothrow;
    void TF_FunctionSetAttrValueProto(TF_Function*, const(char)*, const(void)*, c_ulong, TF_Status*) @nogc nothrow;
    void TF_FunctionGetAttrValueProto(TF_Function*, const(char)*, TF_Buffer*, TF_Status*) @nogc nothrow;
    void TF_DeleteFunction(TF_Function*) @nogc nothrow;
    ubyte TF_TryEvaluateConstant(TF_Graph*, TF_Output, TF_Tensor**, TF_Status*) @nogc nothrow;
    struct TF_Session;
    TF_Session* TF_NewSession(TF_Graph*, const(TF_SessionOptions)*, TF_Status*) @nogc nothrow;
    TF_Session* TF_LoadSessionFromSavedModel(const(TF_SessionOptions)*, const(TF_Buffer)*, const(char)*, const(const(char)*)*, int, TF_Graph*, TF_Buffer*, TF_Status*) @nogc nothrow;
    void TF_CloseSession(TF_Session*, TF_Status*) @nogc nothrow;
    void TF_DeleteSession(TF_Session*, TF_Status*) @nogc nothrow;
    void TF_SessionRun(TF_Session*, const(TF_Buffer)*, const(TF_Output)*, TF_Tensor**, int, const(TF_Output)*, TF_Tensor**, int, const(const(TF_Operation)*)*, int, TF_Buffer*, TF_Status*) @nogc nothrow;
    void TF_SessionPRunSetup(TF_Session*, const(TF_Output)*, int, const(TF_Output)*, int, const(const(TF_Operation)*)*, int, const(char)**, TF_Status*) @nogc nothrow;
    void TF_SessionPRun(TF_Session*, const(char)*, const(TF_Output)*, TF_Tensor**, int, const(TF_Output)*, TF_Tensor**, int, const(const(TF_Operation)*)*, int, TF_Status*) @nogc nothrow;
    void TF_DeletePRunHandle(const(char)*) @nogc nothrow;
    struct TF_DeprecatedSession;
    TF_DeprecatedSession* TF_NewDeprecatedSession(const(TF_SessionOptions)*, TF_Status*) @nogc nothrow;
    void TF_CloseDeprecatedSession(TF_DeprecatedSession*, TF_Status*) @nogc nothrow;
    void TF_DeleteDeprecatedSession(TF_DeprecatedSession*, TF_Status*) @nogc nothrow;
    void TF_Reset(const(TF_SessionOptions)*, const(char)**, int, TF_Status*) @nogc nothrow;
    void TF_ExtendGraph(TF_DeprecatedSession*, const(void)*, c_ulong, TF_Status*) @nogc nothrow;
    void TF_Run(TF_DeprecatedSession*, const(TF_Buffer)*, const(char)**, TF_Tensor**, int, const(char)**, TF_Tensor**, int, const(char)**, int, TF_Buffer*, TF_Status*) @nogc nothrow;
    void TF_PRunSetup(TF_DeprecatedSession*, const(char)**, int, const(char)**, int, const(char)**, int, const(char)**, TF_Status*) @nogc nothrow;
    void TF_PRun(TF_DeprecatedSession*, const(char)*, const(char)**, TF_Tensor**, int, const(char)**, TF_Tensor**, int, const(char)**, int, TF_Status*) @nogc nothrow;
    struct TF_DeviceList;
    TF_DeviceList* TF_SessionListDevices(TF_Session*, TF_Status*) @nogc nothrow;
    TF_DeviceList* TF_DeprecatedSessionListDevices(TF_DeprecatedSession*, TF_Status*) @nogc nothrow;
    void TF_DeleteDeviceList(TF_DeviceList*) @nogc nothrow;
    int TF_DeviceListCount(const(TF_DeviceList)*) @nogc nothrow;
    const(char)* TF_DeviceListName(const(TF_DeviceList)*, int, TF_Status*) @nogc nothrow;
    const(char)* TF_DeviceListType(const(TF_DeviceList)*, int, TF_Status*) @nogc nothrow;
    c_long TF_DeviceListMemoryBytes(const(TF_DeviceList)*, int, TF_Status*) @nogc nothrow;
    c_ulong TF_DeviceListIncarnation(const(TF_DeviceList)*, int, TF_Status*) @nogc nothrow;
    struct TF_Library;
    TF_Library* TF_LoadLibrary(const(char)*, TF_Status*) @nogc nothrow;
    TF_Buffer TF_GetOpList(TF_Library*) @nogc nothrow;
    void TF_DeleteLibraryHandle(TF_Library*) @nogc nothrow;
    TF_Buffer* TF_GetAllOpList() @nogc nothrow;
    struct TF_ApiDefMap;
    TF_ApiDefMap* TF_NewApiDefMap(TF_Buffer*, TF_Status*) @nogc nothrow;
    void TF_DeleteApiDefMap(TF_ApiDefMap*) @nogc nothrow;
    void TF_ApiDefMapPut(TF_ApiDefMap*, const(char)*, c_ulong, TF_Status*) @nogc nothrow;
    TF_Buffer* TF_ApiDefMapGet(TF_ApiDefMap*, const(char)*, c_ulong, TF_Status*) @nogc nothrow;
    TF_Buffer* TF_GetAllRegisteredKernels(TF_Status*) @nogc nothrow;
    TF_Buffer* TF_GetRegisteredKernelsForOp(const(char)*, TF_Status*) @nogc nothrow;
    struct TF_Server;
    TF_Server* TF_NewServer(const(void)*, c_ulong, TF_Status*) @nogc nothrow;
    void TF_ServerStart(TF_Server*, TF_Status*) @nogc nothrow;
    void TF_ServerStop(TF_Server*, TF_Status*) @nogc nothrow;
    void TF_ServerJoin(TF_Server*, TF_Status*) @nogc nothrow;
    const(char)* TF_ServerTarget(TF_Server*) @nogc nothrow;
    void TF_DeleteServer(TF_Server*) @nogc nothrow;
    void TF_RegisterLogListener(void function(const(char)*)) @nogc nothrow;
    struct max_align_t
    {
        long __clang_max_align_nonce1;
        real __clang_max_align_nonce2;
    }
    alias ptrdiff_t = c_long;
    alias size_t = c_ulong;
    alias wchar_t = int;



    static if(!is(typeof(NULL))) {
        private enum enumMixinStr_NULL = `enum NULL = ( cast( void * ) 0 );`;
        static if(is(typeof({ mixin(enumMixinStr_NULL); }))) {
            mixin(enumMixinStr_NULL);
        }
    }
    static if(!is(typeof(_FEATURES_H))) {
        private enum enumMixinStr__FEATURES_H = `enum _FEATURES_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__FEATURES_H); }))) {
            mixin(enumMixinStr__FEATURES_H);
        }
    }
    static if(!is(typeof(__bool_true_false_are_defined))) {
        private enum enumMixinStr___bool_true_false_are_defined = `enum __bool_true_false_are_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___bool_true_false_are_defined); }))) {
            mixin(enumMixinStr___bool_true_false_are_defined);
        }
    }




    static if(!is(typeof(false_))) {
        private enum enumMixinStr_false_ = `enum false_ = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_false_); }))) {
            mixin(enumMixinStr_false_);
        }
    }
    static if(!is(typeof(_DEFAULT_SOURCE))) {
        private enum enumMixinStr__DEFAULT_SOURCE = `enum _DEFAULT_SOURCE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__DEFAULT_SOURCE); }))) {
            mixin(enumMixinStr__DEFAULT_SOURCE);
        }
    }




    static if(!is(typeof(true_))) {
        private enum enumMixinStr_true_ = `enum true_ = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_true_); }))) {
            mixin(enumMixinStr_true_);
        }
    }




    static if(!is(typeof(bool_))) {
        private enum enumMixinStr_bool_ = `enum bool_ = _Bool;`;
        static if(is(typeof({ mixin(enumMixinStr_bool_); }))) {
            mixin(enumMixinStr_bool_);
        }
    }




    static if(!is(typeof(__USE_ISOC11))) {
        private enum enumMixinStr___USE_ISOC11 = `enum __USE_ISOC11 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_ISOC11); }))) {
            mixin(enumMixinStr___USE_ISOC11);
        }
    }
    static if(!is(typeof(__USE_ISOC99))) {
        private enum enumMixinStr___USE_ISOC99 = `enum __USE_ISOC99 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_ISOC99); }))) {
            mixin(enumMixinStr___USE_ISOC99);
        }
    }




    static if(!is(typeof(TF_CAPI_EXPORT))) {
        private enum enumMixinStr_TF_CAPI_EXPORT = `enum TF_CAPI_EXPORT = __attribute__ ( ( visibility ( "default" ) ) );`;
        static if(is(typeof({ mixin(enumMixinStr_TF_CAPI_EXPORT); }))) {
            mixin(enumMixinStr_TF_CAPI_EXPORT);
        }
    }






    static if(!is(typeof(__USE_ISOC95))) {
        private enum enumMixinStr___USE_ISOC95 = `enum __USE_ISOC95 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_ISOC95); }))) {
            mixin(enumMixinStr___USE_ISOC95);
        }
    }




    static if(!is(typeof(__USE_POSIX_IMPLICITLY))) {
        private enum enumMixinStr___USE_POSIX_IMPLICITLY = `enum __USE_POSIX_IMPLICITLY = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_POSIX_IMPLICITLY); }))) {
            mixin(enumMixinStr___USE_POSIX_IMPLICITLY);
        }
    }




    static if(!is(typeof(_POSIX_SOURCE))) {
        private enum enumMixinStr__POSIX_SOURCE = `enum _POSIX_SOURCE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_SOURCE); }))) {
            mixin(enumMixinStr__POSIX_SOURCE);
        }
    }




    static if(!is(typeof(_POSIX_C_SOURCE))) {
        private enum enumMixinStr__POSIX_C_SOURCE = `enum _POSIX_C_SOURCE = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_C_SOURCE); }))) {
            mixin(enumMixinStr__POSIX_C_SOURCE);
        }
    }




    static if(!is(typeof(__USE_POSIX))) {
        private enum enumMixinStr___USE_POSIX = `enum __USE_POSIX = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_POSIX); }))) {
            mixin(enumMixinStr___USE_POSIX);
        }
    }




    static if(!is(typeof(__USE_POSIX2))) {
        private enum enumMixinStr___USE_POSIX2 = `enum __USE_POSIX2 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_POSIX2); }))) {
            mixin(enumMixinStr___USE_POSIX2);
        }
    }




    static if(!is(typeof(__USE_POSIX199309))) {
        private enum enumMixinStr___USE_POSIX199309 = `enum __USE_POSIX199309 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_POSIX199309); }))) {
            mixin(enumMixinStr___USE_POSIX199309);
        }
    }




    static if(!is(typeof(__USE_POSIX199506))) {
        private enum enumMixinStr___USE_POSIX199506 = `enum __USE_POSIX199506 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_POSIX199506); }))) {
            mixin(enumMixinStr___USE_POSIX199506);
        }
    }




    static if(!is(typeof(__USE_XOPEN2K))) {
        private enum enumMixinStr___USE_XOPEN2K = `enum __USE_XOPEN2K = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_XOPEN2K); }))) {
            mixin(enumMixinStr___USE_XOPEN2K);
        }
    }




    static if(!is(typeof(__USE_XOPEN2K8))) {
        private enum enumMixinStr___USE_XOPEN2K8 = `enum __USE_XOPEN2K8 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_XOPEN2K8); }))) {
            mixin(enumMixinStr___USE_XOPEN2K8);
        }
    }




    static if(!is(typeof(_ATFILE_SOURCE))) {
        private enum enumMixinStr__ATFILE_SOURCE = `enum _ATFILE_SOURCE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__ATFILE_SOURCE); }))) {
            mixin(enumMixinStr__ATFILE_SOURCE);
        }
    }




    static if(!is(typeof(__USE_MISC))) {
        private enum enumMixinStr___USE_MISC = `enum __USE_MISC = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_MISC); }))) {
            mixin(enumMixinStr___USE_MISC);
        }
    }




    static if(!is(typeof(__USE_ATFILE))) {
        private enum enumMixinStr___USE_ATFILE = `enum __USE_ATFILE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_ATFILE); }))) {
            mixin(enumMixinStr___USE_ATFILE);
        }
    }




    static if(!is(typeof(__USE_FORTIFY_LEVEL))) {
        private enum enumMixinStr___USE_FORTIFY_LEVEL = `enum __USE_FORTIFY_LEVEL = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_FORTIFY_LEVEL); }))) {
            mixin(enumMixinStr___USE_FORTIFY_LEVEL);
        }
    }




    static if(!is(typeof(__GLIBC_USE_DEPRECATED_GETS))) {
        private enum enumMixinStr___GLIBC_USE_DEPRECATED_GETS = `enum __GLIBC_USE_DEPRECATED_GETS = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_DEPRECATED_GETS); }))) {
            mixin(enumMixinStr___GLIBC_USE_DEPRECATED_GETS);
        }
    }




    static if(!is(typeof(__GNU_LIBRARY__))) {
        private enum enumMixinStr___GNU_LIBRARY__ = `enum __GNU_LIBRARY__ = 6;`;
        static if(is(typeof({ mixin(enumMixinStr___GNU_LIBRARY__); }))) {
            mixin(enumMixinStr___GNU_LIBRARY__);
        }
    }




    static if(!is(typeof(__GLIBC__))) {
        private enum enumMixinStr___GLIBC__ = `enum __GLIBC__ = 2;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC__); }))) {
            mixin(enumMixinStr___GLIBC__);
        }
    }




    static if(!is(typeof(__GLIBC_MINOR__))) {
        private enum enumMixinStr___GLIBC_MINOR__ = `enum __GLIBC_MINOR__ = 27;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_MINOR__); }))) {
            mixin(enumMixinStr___GLIBC_MINOR__);
        }
    }






    static if(!is(typeof(_STDC_PREDEF_H))) {
        private enum enumMixinStr__STDC_PREDEF_H = `enum _STDC_PREDEF_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__STDC_PREDEF_H); }))) {
            mixin(enumMixinStr__STDC_PREDEF_H);
        }
    }




    static if(!is(typeof(_STDINT_H))) {
        private enum enumMixinStr__STDINT_H = `enum _STDINT_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__STDINT_H); }))) {
            mixin(enumMixinStr__STDINT_H);
        }
    }
    static if(!is(typeof(INT8_MIN))) {
        private enum enumMixinStr_INT8_MIN = `enum INT8_MIN = ( - 128 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT8_MIN); }))) {
            mixin(enumMixinStr_INT8_MIN);
        }
    }




    static if(!is(typeof(INT16_MIN))) {
        private enum enumMixinStr_INT16_MIN = `enum INT16_MIN = ( - 32767 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT16_MIN); }))) {
            mixin(enumMixinStr_INT16_MIN);
        }
    }




    static if(!is(typeof(INT32_MIN))) {
        private enum enumMixinStr_INT32_MIN = `enum INT32_MIN = ( - 2147483647 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT32_MIN); }))) {
            mixin(enumMixinStr_INT32_MIN);
        }
    }




    static if(!is(typeof(INT64_MIN))) {
        private enum enumMixinStr_INT64_MIN = `enum INT64_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT64_MIN); }))) {
            mixin(enumMixinStr_INT64_MIN);
        }
    }




    static if(!is(typeof(INT8_MAX))) {
        private enum enumMixinStr_INT8_MAX = `enum INT8_MAX = ( 127 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT8_MAX); }))) {
            mixin(enumMixinStr_INT8_MAX);
        }
    }




    static if(!is(typeof(INT16_MAX))) {
        private enum enumMixinStr_INT16_MAX = `enum INT16_MAX = ( 32767 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT16_MAX); }))) {
            mixin(enumMixinStr_INT16_MAX);
        }
    }




    static if(!is(typeof(INT32_MAX))) {
        private enum enumMixinStr_INT32_MAX = `enum INT32_MAX = ( 2147483647 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT32_MAX); }))) {
            mixin(enumMixinStr_INT32_MAX);
        }
    }




    static if(!is(typeof(INT64_MAX))) {
        private enum enumMixinStr_INT64_MAX = `enum INT64_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INT64_MAX); }))) {
            mixin(enumMixinStr_INT64_MAX);
        }
    }




    static if(!is(typeof(UINT8_MAX))) {
        private enum enumMixinStr_UINT8_MAX = `enum UINT8_MAX = ( 255 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT8_MAX); }))) {
            mixin(enumMixinStr_UINT8_MAX);
        }
    }




    static if(!is(typeof(UINT16_MAX))) {
        private enum enumMixinStr_UINT16_MAX = `enum UINT16_MAX = ( 65535 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT16_MAX); }))) {
            mixin(enumMixinStr_UINT16_MAX);
        }
    }




    static if(!is(typeof(UINT32_MAX))) {
        private enum enumMixinStr_UINT32_MAX = `enum UINT32_MAX = ( 4294967295U );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT32_MAX); }))) {
            mixin(enumMixinStr_UINT32_MAX);
        }
    }




    static if(!is(typeof(UINT64_MAX))) {
        private enum enumMixinStr_UINT64_MAX = `enum UINT64_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT64_MAX); }))) {
            mixin(enumMixinStr_UINT64_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST8_MIN))) {
        private enum enumMixinStr_INT_LEAST8_MIN = `enum INT_LEAST8_MIN = ( - 128 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST8_MIN); }))) {
            mixin(enumMixinStr_INT_LEAST8_MIN);
        }
    }




    static if(!is(typeof(INT_LEAST16_MIN))) {
        private enum enumMixinStr_INT_LEAST16_MIN = `enum INT_LEAST16_MIN = ( - 32767 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST16_MIN); }))) {
            mixin(enumMixinStr_INT_LEAST16_MIN);
        }
    }




    static if(!is(typeof(INT_LEAST32_MIN))) {
        private enum enumMixinStr_INT_LEAST32_MIN = `enum INT_LEAST32_MIN = ( - 2147483647 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST32_MIN); }))) {
            mixin(enumMixinStr_INT_LEAST32_MIN);
        }
    }




    static if(!is(typeof(INT_LEAST64_MIN))) {
        private enum enumMixinStr_INT_LEAST64_MIN = `enum INT_LEAST64_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST64_MIN); }))) {
            mixin(enumMixinStr_INT_LEAST64_MIN);
        }
    }




    static if(!is(typeof(INT_LEAST8_MAX))) {
        private enum enumMixinStr_INT_LEAST8_MAX = `enum INT_LEAST8_MAX = ( 127 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST8_MAX); }))) {
            mixin(enumMixinStr_INT_LEAST8_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST16_MAX))) {
        private enum enumMixinStr_INT_LEAST16_MAX = `enum INT_LEAST16_MAX = ( 32767 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST16_MAX); }))) {
            mixin(enumMixinStr_INT_LEAST16_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST32_MAX))) {
        private enum enumMixinStr_INT_LEAST32_MAX = `enum INT_LEAST32_MAX = ( 2147483647 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST32_MAX); }))) {
            mixin(enumMixinStr_INT_LEAST32_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST64_MAX))) {
        private enum enumMixinStr_INT_LEAST64_MAX = `enum INT_LEAST64_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST64_MAX); }))) {
            mixin(enumMixinStr_INT_LEAST64_MAX);
        }
    }




    static if(!is(typeof(UINT_LEAST8_MAX))) {
        private enum enumMixinStr_UINT_LEAST8_MAX = `enum UINT_LEAST8_MAX = ( 255 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_LEAST8_MAX); }))) {
            mixin(enumMixinStr_UINT_LEAST8_MAX);
        }
    }




    static if(!is(typeof(UINT_LEAST16_MAX))) {
        private enum enumMixinStr_UINT_LEAST16_MAX = `enum UINT_LEAST16_MAX = ( 65535 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_LEAST16_MAX); }))) {
            mixin(enumMixinStr_UINT_LEAST16_MAX);
        }
    }




    static if(!is(typeof(UINT_LEAST32_MAX))) {
        private enum enumMixinStr_UINT_LEAST32_MAX = `enum UINT_LEAST32_MAX = ( 4294967295U );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_LEAST32_MAX); }))) {
            mixin(enumMixinStr_UINT_LEAST32_MAX);
        }
    }




    static if(!is(typeof(UINT_LEAST64_MAX))) {
        private enum enumMixinStr_UINT_LEAST64_MAX = `enum UINT_LEAST64_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_LEAST64_MAX); }))) {
            mixin(enumMixinStr_UINT_LEAST64_MAX);
        }
    }




    static if(!is(typeof(INT_FAST8_MIN))) {
        private enum enumMixinStr_INT_FAST8_MIN = `enum INT_FAST8_MIN = ( - 128 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST8_MIN); }))) {
            mixin(enumMixinStr_INT_FAST8_MIN);
        }
    }




    static if(!is(typeof(INT_FAST16_MIN))) {
        private enum enumMixinStr_INT_FAST16_MIN = `enum INT_FAST16_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST16_MIN); }))) {
            mixin(enumMixinStr_INT_FAST16_MIN);
        }
    }




    static if(!is(typeof(INT_FAST32_MIN))) {
        private enum enumMixinStr_INT_FAST32_MIN = `enum INT_FAST32_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST32_MIN); }))) {
            mixin(enumMixinStr_INT_FAST32_MIN);
        }
    }




    static if(!is(typeof(INT_FAST64_MIN))) {
        private enum enumMixinStr_INT_FAST64_MIN = `enum INT_FAST64_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST64_MIN); }))) {
            mixin(enumMixinStr_INT_FAST64_MIN);
        }
    }




    static if(!is(typeof(INT_FAST8_MAX))) {
        private enum enumMixinStr_INT_FAST8_MAX = `enum INT_FAST8_MAX = ( 127 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST8_MAX); }))) {
            mixin(enumMixinStr_INT_FAST8_MAX);
        }
    }




    static if(!is(typeof(INT_FAST16_MAX))) {
        private enum enumMixinStr_INT_FAST16_MAX = `enum INT_FAST16_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST16_MAX); }))) {
            mixin(enumMixinStr_INT_FAST16_MAX);
        }
    }




    static if(!is(typeof(INT_FAST32_MAX))) {
        private enum enumMixinStr_INT_FAST32_MAX = `enum INT_FAST32_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST32_MAX); }))) {
            mixin(enumMixinStr_INT_FAST32_MAX);
        }
    }




    static if(!is(typeof(INT_FAST64_MAX))) {
        private enum enumMixinStr_INT_FAST64_MAX = `enum INT_FAST64_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST64_MAX); }))) {
            mixin(enumMixinStr_INT_FAST64_MAX);
        }
    }




    static if(!is(typeof(UINT_FAST8_MAX))) {
        private enum enumMixinStr_UINT_FAST8_MAX = `enum UINT_FAST8_MAX = ( 255 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_FAST8_MAX); }))) {
            mixin(enumMixinStr_UINT_FAST8_MAX);
        }
    }




    static if(!is(typeof(UINT_FAST16_MAX))) {
        private enum enumMixinStr_UINT_FAST16_MAX = `enum UINT_FAST16_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_FAST16_MAX); }))) {
            mixin(enumMixinStr_UINT_FAST16_MAX);
        }
    }




    static if(!is(typeof(UINT_FAST32_MAX))) {
        private enum enumMixinStr_UINT_FAST32_MAX = `enum UINT_FAST32_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_FAST32_MAX); }))) {
            mixin(enumMixinStr_UINT_FAST32_MAX);
        }
    }




    static if(!is(typeof(UINT_FAST64_MAX))) {
        private enum enumMixinStr_UINT_FAST64_MAX = `enum UINT_FAST64_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_FAST64_MAX); }))) {
            mixin(enumMixinStr_UINT_FAST64_MAX);
        }
    }




    static if(!is(typeof(INTPTR_MIN))) {
        private enum enumMixinStr_INTPTR_MIN = `enum INTPTR_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INTPTR_MIN); }))) {
            mixin(enumMixinStr_INTPTR_MIN);
        }
    }




    static if(!is(typeof(INTPTR_MAX))) {
        private enum enumMixinStr_INTPTR_MAX = `enum INTPTR_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INTPTR_MAX); }))) {
            mixin(enumMixinStr_INTPTR_MAX);
        }
    }




    static if(!is(typeof(UINTPTR_MAX))) {
        private enum enumMixinStr_UINTPTR_MAX = `enum UINTPTR_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINTPTR_MAX); }))) {
            mixin(enumMixinStr_UINTPTR_MAX);
        }
    }




    static if(!is(typeof(INTMAX_MIN))) {
        private enum enumMixinStr_INTMAX_MIN = `enum INTMAX_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INTMAX_MIN); }))) {
            mixin(enumMixinStr_INTMAX_MIN);
        }
    }




    static if(!is(typeof(INTMAX_MAX))) {
        private enum enumMixinStr_INTMAX_MAX = `enum INTMAX_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INTMAX_MAX); }))) {
            mixin(enumMixinStr_INTMAX_MAX);
        }
    }




    static if(!is(typeof(UINTMAX_MAX))) {
        private enum enumMixinStr_UINTMAX_MAX = `enum UINTMAX_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINTMAX_MAX); }))) {
            mixin(enumMixinStr_UINTMAX_MAX);
        }
    }




    static if(!is(typeof(PTRDIFF_MIN))) {
        private enum enumMixinStr_PTRDIFF_MIN = `enum PTRDIFF_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_PTRDIFF_MIN); }))) {
            mixin(enumMixinStr_PTRDIFF_MIN);
        }
    }




    static if(!is(typeof(PTRDIFF_MAX))) {
        private enum enumMixinStr_PTRDIFF_MAX = `enum PTRDIFF_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_PTRDIFF_MAX); }))) {
            mixin(enumMixinStr_PTRDIFF_MAX);
        }
    }




    static if(!is(typeof(SIG_ATOMIC_MIN))) {
        private enum enumMixinStr_SIG_ATOMIC_MIN = `enum SIG_ATOMIC_MIN = ( - 2147483647 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_SIG_ATOMIC_MIN); }))) {
            mixin(enumMixinStr_SIG_ATOMIC_MIN);
        }
    }




    static if(!is(typeof(SIG_ATOMIC_MAX))) {
        private enum enumMixinStr_SIG_ATOMIC_MAX = `enum SIG_ATOMIC_MAX = ( 2147483647 );`;
        static if(is(typeof({ mixin(enumMixinStr_SIG_ATOMIC_MAX); }))) {
            mixin(enumMixinStr_SIG_ATOMIC_MAX);
        }
    }




    static if(!is(typeof(SIZE_MAX))) {
        private enum enumMixinStr_SIZE_MAX = `enum SIZE_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_SIZE_MAX); }))) {
            mixin(enumMixinStr_SIZE_MAX);
        }
    }




    static if(!is(typeof(WCHAR_MIN))) {
        private enum enumMixinStr_WCHAR_MIN = `enum WCHAR_MIN = __WCHAR_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr_WCHAR_MIN); }))) {
            mixin(enumMixinStr_WCHAR_MIN);
        }
    }




    static if(!is(typeof(WCHAR_MAX))) {
        private enum enumMixinStr_WCHAR_MAX = `enum WCHAR_MAX = __WCHAR_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr_WCHAR_MAX); }))) {
            mixin(enumMixinStr_WCHAR_MAX);
        }
    }




    static if(!is(typeof(WINT_MIN))) {
        private enum enumMixinStr_WINT_MIN = `enum WINT_MIN = ( 0u );`;
        static if(is(typeof({ mixin(enumMixinStr_WINT_MIN); }))) {
            mixin(enumMixinStr_WINT_MIN);
        }
    }




    static if(!is(typeof(WINT_MAX))) {
        private enum enumMixinStr_WINT_MAX = `enum WINT_MAX = ( 4294967295u );`;
        static if(is(typeof({ mixin(enumMixinStr_WINT_MAX); }))) {
            mixin(enumMixinStr_WINT_MAX);
        }
    }
    static if(!is(typeof(__GLIBC_USE_LIB_EXT2))) {
        private enum enumMixinStr___GLIBC_USE_LIB_EXT2 = `enum __GLIBC_USE_LIB_EXT2 = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_LIB_EXT2); }))) {
            mixin(enumMixinStr___GLIBC_USE_LIB_EXT2);
        }
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_BFP_EXT))) {
        private enum enumMixinStr___GLIBC_USE_IEC_60559_BFP_EXT = `enum __GLIBC_USE_IEC_60559_BFP_EXT = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_IEC_60559_BFP_EXT); }))) {
            mixin(enumMixinStr___GLIBC_USE_IEC_60559_BFP_EXT);
        }
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_FUNCS_EXT))) {
        private enum enumMixinStr___GLIBC_USE_IEC_60559_FUNCS_EXT = `enum __GLIBC_USE_IEC_60559_FUNCS_EXT = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_IEC_60559_FUNCS_EXT); }))) {
            mixin(enumMixinStr___GLIBC_USE_IEC_60559_FUNCS_EXT);
        }
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_TYPES_EXT))) {
        private enum enumMixinStr___GLIBC_USE_IEC_60559_TYPES_EXT = `enum __GLIBC_USE_IEC_60559_TYPES_EXT = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_IEC_60559_TYPES_EXT); }))) {
            mixin(enumMixinStr___GLIBC_USE_IEC_60559_TYPES_EXT);
        }
    }




    static if(!is(typeof(_BITS_STDINT_INTN_H))) {
        private enum enumMixinStr__BITS_STDINT_INTN_H = `enum _BITS_STDINT_INTN_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_STDINT_INTN_H); }))) {
            mixin(enumMixinStr__BITS_STDINT_INTN_H);
        }
    }




    static if(!is(typeof(_BITS_STDINT_UINTN_H))) {
        private enum enumMixinStr__BITS_STDINT_UINTN_H = `enum _BITS_STDINT_UINTN_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_STDINT_UINTN_H); }))) {
            mixin(enumMixinStr__BITS_STDINT_UINTN_H);
        }
    }




    static if(!is(typeof(_BITS_TYPES_H))) {
        private enum enumMixinStr__BITS_TYPES_H = `enum _BITS_TYPES_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_TYPES_H); }))) {
            mixin(enumMixinStr__BITS_TYPES_H);
        }
    }




    static if(!is(typeof(__S16_TYPE))) {
        private enum enumMixinStr___S16_TYPE = `enum __S16_TYPE = short int;`;
        static if(is(typeof({ mixin(enumMixinStr___S16_TYPE); }))) {
            mixin(enumMixinStr___S16_TYPE);
        }
    }




    static if(!is(typeof(__U16_TYPE))) {
        private enum enumMixinStr___U16_TYPE = `enum __U16_TYPE = unsigned short int;`;
        static if(is(typeof({ mixin(enumMixinStr___U16_TYPE); }))) {
            mixin(enumMixinStr___U16_TYPE);
        }
    }




    static if(!is(typeof(__S32_TYPE))) {
        private enum enumMixinStr___S32_TYPE = `enum __S32_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___S32_TYPE); }))) {
            mixin(enumMixinStr___S32_TYPE);
        }
    }




    static if(!is(typeof(__U32_TYPE))) {
        private enum enumMixinStr___U32_TYPE = `enum __U32_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___U32_TYPE); }))) {
            mixin(enumMixinStr___U32_TYPE);
        }
    }




    static if(!is(typeof(__SLONGWORD_TYPE))) {
        private enum enumMixinStr___SLONGWORD_TYPE = `enum __SLONGWORD_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SLONGWORD_TYPE); }))) {
            mixin(enumMixinStr___SLONGWORD_TYPE);
        }
    }




    static if(!is(typeof(__ULONGWORD_TYPE))) {
        private enum enumMixinStr___ULONGWORD_TYPE = `enum __ULONGWORD_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___ULONGWORD_TYPE); }))) {
            mixin(enumMixinStr___ULONGWORD_TYPE);
        }
    }




    static if(!is(typeof(__SQUAD_TYPE))) {
        private enum enumMixinStr___SQUAD_TYPE = `enum __SQUAD_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SQUAD_TYPE); }))) {
            mixin(enumMixinStr___SQUAD_TYPE);
        }
    }




    static if(!is(typeof(__UQUAD_TYPE))) {
        private enum enumMixinStr___UQUAD_TYPE = `enum __UQUAD_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___UQUAD_TYPE); }))) {
            mixin(enumMixinStr___UQUAD_TYPE);
        }
    }




    static if(!is(typeof(__SWORD_TYPE))) {
        private enum enumMixinStr___SWORD_TYPE = `enum __SWORD_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SWORD_TYPE); }))) {
            mixin(enumMixinStr___SWORD_TYPE);
        }
    }




    static if(!is(typeof(__UWORD_TYPE))) {
        private enum enumMixinStr___UWORD_TYPE = `enum __UWORD_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___UWORD_TYPE); }))) {
            mixin(enumMixinStr___UWORD_TYPE);
        }
    }




    static if(!is(typeof(__SLONG32_TYPE))) {
        private enum enumMixinStr___SLONG32_TYPE = `enum __SLONG32_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___SLONG32_TYPE); }))) {
            mixin(enumMixinStr___SLONG32_TYPE);
        }
    }




    static if(!is(typeof(__ULONG32_TYPE))) {
        private enum enumMixinStr___ULONG32_TYPE = `enum __ULONG32_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___ULONG32_TYPE); }))) {
            mixin(enumMixinStr___ULONG32_TYPE);
        }
    }




    static if(!is(typeof(__S64_TYPE))) {
        private enum enumMixinStr___S64_TYPE = `enum __S64_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___S64_TYPE); }))) {
            mixin(enumMixinStr___S64_TYPE);
        }
    }




    static if(!is(typeof(__U64_TYPE))) {
        private enum enumMixinStr___U64_TYPE = `enum __U64_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___U64_TYPE); }))) {
            mixin(enumMixinStr___U64_TYPE);
        }
    }




    static if(!is(typeof(__STD_TYPE))) {
        private enum enumMixinStr___STD_TYPE = `enum __STD_TYPE = typedef;`;
        static if(is(typeof({ mixin(enumMixinStr___STD_TYPE); }))) {
            mixin(enumMixinStr___STD_TYPE);
        }
    }




    static if(!is(typeof(_BITS_TYPESIZES_H))) {
        private enum enumMixinStr__BITS_TYPESIZES_H = `enum _BITS_TYPESIZES_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_TYPESIZES_H); }))) {
            mixin(enumMixinStr__BITS_TYPESIZES_H);
        }
    }




    static if(!is(typeof(__SYSCALL_SLONG_TYPE))) {
        private enum enumMixinStr___SYSCALL_SLONG_TYPE = `enum __SYSCALL_SLONG_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SYSCALL_SLONG_TYPE); }))) {
            mixin(enumMixinStr___SYSCALL_SLONG_TYPE);
        }
    }




    static if(!is(typeof(__SYSCALL_ULONG_TYPE))) {
        private enum enumMixinStr___SYSCALL_ULONG_TYPE = `enum __SYSCALL_ULONG_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SYSCALL_ULONG_TYPE); }))) {
            mixin(enumMixinStr___SYSCALL_ULONG_TYPE);
        }
    }




    static if(!is(typeof(__DEV_T_TYPE))) {
        private enum enumMixinStr___DEV_T_TYPE = `enum __DEV_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___DEV_T_TYPE); }))) {
            mixin(enumMixinStr___DEV_T_TYPE);
        }
    }




    static if(!is(typeof(__UID_T_TYPE))) {
        private enum enumMixinStr___UID_T_TYPE = `enum __UID_T_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___UID_T_TYPE); }))) {
            mixin(enumMixinStr___UID_T_TYPE);
        }
    }




    static if(!is(typeof(__GID_T_TYPE))) {
        private enum enumMixinStr___GID_T_TYPE = `enum __GID_T_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___GID_T_TYPE); }))) {
            mixin(enumMixinStr___GID_T_TYPE);
        }
    }




    static if(!is(typeof(__INO_T_TYPE))) {
        private enum enumMixinStr___INO_T_TYPE = `enum __INO_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___INO_T_TYPE); }))) {
            mixin(enumMixinStr___INO_T_TYPE);
        }
    }




    static if(!is(typeof(__INO64_T_TYPE))) {
        private enum enumMixinStr___INO64_T_TYPE = `enum __INO64_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___INO64_T_TYPE); }))) {
            mixin(enumMixinStr___INO64_T_TYPE);
        }
    }




    static if(!is(typeof(__MODE_T_TYPE))) {
        private enum enumMixinStr___MODE_T_TYPE = `enum __MODE_T_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___MODE_T_TYPE); }))) {
            mixin(enumMixinStr___MODE_T_TYPE);
        }
    }




    static if(!is(typeof(__NLINK_T_TYPE))) {
        private enum enumMixinStr___NLINK_T_TYPE = `enum __NLINK_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___NLINK_T_TYPE); }))) {
            mixin(enumMixinStr___NLINK_T_TYPE);
        }
    }




    static if(!is(typeof(__FSWORD_T_TYPE))) {
        private enum enumMixinStr___FSWORD_T_TYPE = `enum __FSWORD_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___FSWORD_T_TYPE); }))) {
            mixin(enumMixinStr___FSWORD_T_TYPE);
        }
    }




    static if(!is(typeof(__OFF_T_TYPE))) {
        private enum enumMixinStr___OFF_T_TYPE = `enum __OFF_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___OFF_T_TYPE); }))) {
            mixin(enumMixinStr___OFF_T_TYPE);
        }
    }




    static if(!is(typeof(__OFF64_T_TYPE))) {
        private enum enumMixinStr___OFF64_T_TYPE = `enum __OFF64_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___OFF64_T_TYPE); }))) {
            mixin(enumMixinStr___OFF64_T_TYPE);
        }
    }




    static if(!is(typeof(__PID_T_TYPE))) {
        private enum enumMixinStr___PID_T_TYPE = `enum __PID_T_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___PID_T_TYPE); }))) {
            mixin(enumMixinStr___PID_T_TYPE);
        }
    }




    static if(!is(typeof(__RLIM_T_TYPE))) {
        private enum enumMixinStr___RLIM_T_TYPE = `enum __RLIM_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___RLIM_T_TYPE); }))) {
            mixin(enumMixinStr___RLIM_T_TYPE);
        }
    }




    static if(!is(typeof(__RLIM64_T_TYPE))) {
        private enum enumMixinStr___RLIM64_T_TYPE = `enum __RLIM64_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___RLIM64_T_TYPE); }))) {
            mixin(enumMixinStr___RLIM64_T_TYPE);
        }
    }




    static if(!is(typeof(__BLKCNT_T_TYPE))) {
        private enum enumMixinStr___BLKCNT_T_TYPE = `enum __BLKCNT_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___BLKCNT_T_TYPE); }))) {
            mixin(enumMixinStr___BLKCNT_T_TYPE);
        }
    }




    static if(!is(typeof(__BLKCNT64_T_TYPE))) {
        private enum enumMixinStr___BLKCNT64_T_TYPE = `enum __BLKCNT64_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___BLKCNT64_T_TYPE); }))) {
            mixin(enumMixinStr___BLKCNT64_T_TYPE);
        }
    }




    static if(!is(typeof(__FSBLKCNT_T_TYPE))) {
        private enum enumMixinStr___FSBLKCNT_T_TYPE = `enum __FSBLKCNT_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___FSBLKCNT_T_TYPE); }))) {
            mixin(enumMixinStr___FSBLKCNT_T_TYPE);
        }
    }




    static if(!is(typeof(__FSBLKCNT64_T_TYPE))) {
        private enum enumMixinStr___FSBLKCNT64_T_TYPE = `enum __FSBLKCNT64_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___FSBLKCNT64_T_TYPE); }))) {
            mixin(enumMixinStr___FSBLKCNT64_T_TYPE);
        }
    }




    static if(!is(typeof(__FSFILCNT_T_TYPE))) {
        private enum enumMixinStr___FSFILCNT_T_TYPE = `enum __FSFILCNT_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___FSFILCNT_T_TYPE); }))) {
            mixin(enumMixinStr___FSFILCNT_T_TYPE);
        }
    }




    static if(!is(typeof(__FSFILCNT64_T_TYPE))) {
        private enum enumMixinStr___FSFILCNT64_T_TYPE = `enum __FSFILCNT64_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___FSFILCNT64_T_TYPE); }))) {
            mixin(enumMixinStr___FSFILCNT64_T_TYPE);
        }
    }




    static if(!is(typeof(__ID_T_TYPE))) {
        private enum enumMixinStr___ID_T_TYPE = `enum __ID_T_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___ID_T_TYPE); }))) {
            mixin(enumMixinStr___ID_T_TYPE);
        }
    }




    static if(!is(typeof(__CLOCK_T_TYPE))) {
        private enum enumMixinStr___CLOCK_T_TYPE = `enum __CLOCK_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___CLOCK_T_TYPE); }))) {
            mixin(enumMixinStr___CLOCK_T_TYPE);
        }
    }




    static if(!is(typeof(__TIME_T_TYPE))) {
        private enum enumMixinStr___TIME_T_TYPE = `enum __TIME_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___TIME_T_TYPE); }))) {
            mixin(enumMixinStr___TIME_T_TYPE);
        }
    }




    static if(!is(typeof(__USECONDS_T_TYPE))) {
        private enum enumMixinStr___USECONDS_T_TYPE = `enum __USECONDS_T_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___USECONDS_T_TYPE); }))) {
            mixin(enumMixinStr___USECONDS_T_TYPE);
        }
    }




    static if(!is(typeof(__SUSECONDS_T_TYPE))) {
        private enum enumMixinStr___SUSECONDS_T_TYPE = `enum __SUSECONDS_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SUSECONDS_T_TYPE); }))) {
            mixin(enumMixinStr___SUSECONDS_T_TYPE);
        }
    }




    static if(!is(typeof(__DADDR_T_TYPE))) {
        private enum enumMixinStr___DADDR_T_TYPE = `enum __DADDR_T_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___DADDR_T_TYPE); }))) {
            mixin(enumMixinStr___DADDR_T_TYPE);
        }
    }




    static if(!is(typeof(__KEY_T_TYPE))) {
        private enum enumMixinStr___KEY_T_TYPE = `enum __KEY_T_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___KEY_T_TYPE); }))) {
            mixin(enumMixinStr___KEY_T_TYPE);
        }
    }




    static if(!is(typeof(__CLOCKID_T_TYPE))) {
        private enum enumMixinStr___CLOCKID_T_TYPE = `enum __CLOCKID_T_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___CLOCKID_T_TYPE); }))) {
            mixin(enumMixinStr___CLOCKID_T_TYPE);
        }
    }




    static if(!is(typeof(__TIMER_T_TYPE))) {
        private enum enumMixinStr___TIMER_T_TYPE = `enum __TIMER_T_TYPE = void *;`;
        static if(is(typeof({ mixin(enumMixinStr___TIMER_T_TYPE); }))) {
            mixin(enumMixinStr___TIMER_T_TYPE);
        }
    }




    static if(!is(typeof(__BLKSIZE_T_TYPE))) {
        private enum enumMixinStr___BLKSIZE_T_TYPE = `enum __BLKSIZE_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___BLKSIZE_T_TYPE); }))) {
            mixin(enumMixinStr___BLKSIZE_T_TYPE);
        }
    }




    static if(!is(typeof(__FSID_T_TYPE))) {
        private enum enumMixinStr___FSID_T_TYPE = `enum __FSID_T_TYPE = { int __val [ 2 ] ; };`;
        static if(is(typeof({ mixin(enumMixinStr___FSID_T_TYPE); }))) {
            mixin(enumMixinStr___FSID_T_TYPE);
        }
    }




    static if(!is(typeof(__SSIZE_T_TYPE))) {
        private enum enumMixinStr___SSIZE_T_TYPE = `enum __SSIZE_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SSIZE_T_TYPE); }))) {
            mixin(enumMixinStr___SSIZE_T_TYPE);
        }
    }




    static if(!is(typeof(__CPU_MASK_TYPE))) {
        private enum enumMixinStr___CPU_MASK_TYPE = `enum __CPU_MASK_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___CPU_MASK_TYPE); }))) {
            mixin(enumMixinStr___CPU_MASK_TYPE);
        }
    }




    static if(!is(typeof(__OFF_T_MATCHES_OFF64_T))) {
        private enum enumMixinStr___OFF_T_MATCHES_OFF64_T = `enum __OFF_T_MATCHES_OFF64_T = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___OFF_T_MATCHES_OFF64_T); }))) {
            mixin(enumMixinStr___OFF_T_MATCHES_OFF64_T);
        }
    }




    static if(!is(typeof(__INO_T_MATCHES_INO64_T))) {
        private enum enumMixinStr___INO_T_MATCHES_INO64_T = `enum __INO_T_MATCHES_INO64_T = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___INO_T_MATCHES_INO64_T); }))) {
            mixin(enumMixinStr___INO_T_MATCHES_INO64_T);
        }
    }




    static if(!is(typeof(__RLIM_T_MATCHES_RLIM64_T))) {
        private enum enumMixinStr___RLIM_T_MATCHES_RLIM64_T = `enum __RLIM_T_MATCHES_RLIM64_T = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___RLIM_T_MATCHES_RLIM64_T); }))) {
            mixin(enumMixinStr___RLIM_T_MATCHES_RLIM64_T);
        }
    }




    static if(!is(typeof(__FD_SETSIZE))) {
        private enum enumMixinStr___FD_SETSIZE = `enum __FD_SETSIZE = 1024;`;
        static if(is(typeof({ mixin(enumMixinStr___FD_SETSIZE); }))) {
            mixin(enumMixinStr___FD_SETSIZE);
        }
    }




    static if(!is(typeof(_BITS_WCHAR_H))) {
        private enum enumMixinStr__BITS_WCHAR_H = `enum _BITS_WCHAR_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_WCHAR_H); }))) {
            mixin(enumMixinStr__BITS_WCHAR_H);
        }
    }




    static if(!is(typeof(__WCHAR_MAX))) {
        private enum enumMixinStr___WCHAR_MAX = `enum __WCHAR_MAX = 0x7fffffff;`;
        static if(is(typeof({ mixin(enumMixinStr___WCHAR_MAX); }))) {
            mixin(enumMixinStr___WCHAR_MAX);
        }
    }




    static if(!is(typeof(__WCHAR_MIN))) {
        private enum enumMixinStr___WCHAR_MIN = `enum __WCHAR_MIN = ( - 0x7fffffff - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr___WCHAR_MIN); }))) {
            mixin(enumMixinStr___WCHAR_MIN);
        }
    }




    static if(!is(typeof(__WORDSIZE))) {
        private enum enumMixinStr___WORDSIZE = `enum __WORDSIZE = 64;`;
        static if(is(typeof({ mixin(enumMixinStr___WORDSIZE); }))) {
            mixin(enumMixinStr___WORDSIZE);
        }
    }




    static if(!is(typeof(__WORDSIZE_TIME64_COMPAT32))) {
        private enum enumMixinStr___WORDSIZE_TIME64_COMPAT32 = `enum __WORDSIZE_TIME64_COMPAT32 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___WORDSIZE_TIME64_COMPAT32); }))) {
            mixin(enumMixinStr___WORDSIZE_TIME64_COMPAT32);
        }
    }




    static if(!is(typeof(__SYSCALL_WORDSIZE))) {
        private enum enumMixinStr___SYSCALL_WORDSIZE = `enum __SYSCALL_WORDSIZE = 64;`;
        static if(is(typeof({ mixin(enumMixinStr___SYSCALL_WORDSIZE); }))) {
            mixin(enumMixinStr___SYSCALL_WORDSIZE);
        }
    }
    static if(!is(typeof(_SYS_CDEFS_H))) {
        private enum enumMixinStr__SYS_CDEFS_H = `enum _SYS_CDEFS_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__SYS_CDEFS_H); }))) {
            mixin(enumMixinStr__SYS_CDEFS_H);
        }
    }
    static if(!is(typeof(__THROW))) {
        private enum enumMixinStr___THROW = `enum __THROW = __attribute__ ( ( __nothrow__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___THROW); }))) {
            mixin(enumMixinStr___THROW);
        }
    }




    static if(!is(typeof(__THROWNL))) {
        private enum enumMixinStr___THROWNL = `enum __THROWNL = __attribute__ ( ( __nothrow__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___THROWNL); }))) {
            mixin(enumMixinStr___THROWNL);
        }
    }
    static if(!is(typeof(__ptr_t))) {
        private enum enumMixinStr___ptr_t = `enum __ptr_t = void *;`;
        static if(is(typeof({ mixin(enumMixinStr___ptr_t); }))) {
            mixin(enumMixinStr___ptr_t);
        }
    }
    static if(!is(typeof(__flexarr))) {
        private enum enumMixinStr___flexarr = `enum __flexarr = [ ];`;
        static if(is(typeof({ mixin(enumMixinStr___flexarr); }))) {
            mixin(enumMixinStr___flexarr);
        }
    }




    static if(!is(typeof(__glibc_c99_flexarr_available))) {
        private enum enumMixinStr___glibc_c99_flexarr_available = `enum __glibc_c99_flexarr_available = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___glibc_c99_flexarr_available); }))) {
            mixin(enumMixinStr___glibc_c99_flexarr_available);
        }
    }
    static if(!is(typeof(__attribute_malloc__))) {
        private enum enumMixinStr___attribute_malloc__ = `enum __attribute_malloc__ = __attribute__ ( ( __malloc__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_malloc__); }))) {
            mixin(enumMixinStr___attribute_malloc__);
        }
    }






    static if(!is(typeof(__attribute_pure__))) {
        private enum enumMixinStr___attribute_pure__ = `enum __attribute_pure__ = __attribute__ ( ( __pure__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_pure__); }))) {
            mixin(enumMixinStr___attribute_pure__);
        }
    }




    static if(!is(typeof(__attribute_const__))) {
        private enum enumMixinStr___attribute_const__ = `enum __attribute_const__ = __attribute__ ( cast( __const__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_const__); }))) {
            mixin(enumMixinStr___attribute_const__);
        }
    }




    static if(!is(typeof(__attribute_used__))) {
        private enum enumMixinStr___attribute_used__ = `enum __attribute_used__ = __attribute__ ( ( __used__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_used__); }))) {
            mixin(enumMixinStr___attribute_used__);
        }
    }




    static if(!is(typeof(__attribute_noinline__))) {
        private enum enumMixinStr___attribute_noinline__ = `enum __attribute_noinline__ = __attribute__ ( ( __noinline__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_noinline__); }))) {
            mixin(enumMixinStr___attribute_noinline__);
        }
    }




    static if(!is(typeof(__attribute_deprecated__))) {
        private enum enumMixinStr___attribute_deprecated__ = `enum __attribute_deprecated__ = __attribute__ ( ( __deprecated__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_deprecated__); }))) {
            mixin(enumMixinStr___attribute_deprecated__);
        }
    }
    static if(!is(typeof(__attribute_warn_unused_result__))) {
        private enum enumMixinStr___attribute_warn_unused_result__ = `enum __attribute_warn_unused_result__ = __attribute__ ( ( __warn_unused_result__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_warn_unused_result__); }))) {
            mixin(enumMixinStr___attribute_warn_unused_result__);
        }
    }






    static if(!is(typeof(__always_inline))) {
        private enum enumMixinStr___always_inline = `enum __always_inline = __inline __attribute__ ( ( __always_inline__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___always_inline); }))) {
            mixin(enumMixinStr___always_inline);
        }
    }






    static if(!is(typeof(__extern_inline))) {
        private enum enumMixinStr___extern_inline = `enum __extern_inline = extern __inline __attribute__ ( ( __gnu_inline__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___extern_inline); }))) {
            mixin(enumMixinStr___extern_inline);
        }
    }




    static if(!is(typeof(__extern_always_inline))) {
        private enum enumMixinStr___extern_always_inline = `enum __extern_always_inline = extern __inline __attribute__ ( ( __always_inline__ ) ) __attribute__ ( ( __gnu_inline__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___extern_always_inline); }))) {
            mixin(enumMixinStr___extern_always_inline);
        }
    }




    static if(!is(typeof(__fortify_function))) {
        private enum enumMixinStr___fortify_function = `enum __fortify_function = extern __inline __attribute__ ( ( __always_inline__ ) ) __attribute__ ( ( __gnu_inline__ ) ) ;`;
        static if(is(typeof({ mixin(enumMixinStr___fortify_function); }))) {
            mixin(enumMixinStr___fortify_function);
        }
    }




    static if(!is(typeof(__restrict_arr))) {
        private enum enumMixinStr___restrict_arr = `enum __restrict_arr = __restrict;`;
        static if(is(typeof({ mixin(enumMixinStr___restrict_arr); }))) {
            mixin(enumMixinStr___restrict_arr);
        }
    }
    static if(!is(typeof(__HAVE_GENERIC_SELECTION))) {
        private enum enumMixinStr___HAVE_GENERIC_SELECTION = `enum __HAVE_GENERIC_SELECTION = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_GENERIC_SELECTION); }))) {
            mixin(enumMixinStr___HAVE_GENERIC_SELECTION);
        }
    }
}
