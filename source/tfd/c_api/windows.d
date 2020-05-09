module tfd.c_api.windows;


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
    alias size_t = ulong;
    bool TF_TensorIsAligned(const(TF_Tensor)*) @nogc nothrow;
    ulong TF_StringEncodedSize(ulong) @nogc nothrow;
    ulong TF_StringDecode(const(char)*, ulong, const(char)**, ulong*, TF_Status*) @nogc nothrow;
    ulong TF_StringEncode(const(char)*, ulong, char*, ulong, TF_Status*) @nogc nothrow;
    void TF_TensorBitcastFrom(const(TF_Tensor)*, TF_DataType, TF_Tensor*, const(long)*, int, TF_Status*) @nogc nothrow;
    long TF_TensorElementCount(const(TF_Tensor)*) @nogc nothrow;
    void* TF_TensorData(const(TF_Tensor)*) @nogc nothrow;
    ulong TF_TensorByteSize(const(TF_Tensor)*) @nogc nothrow;
    long TF_Dim(const(TF_Tensor)*, int) @nogc nothrow;
    int TF_NumDims(const(TF_Tensor)*) @nogc nothrow;
    TF_DataType TF_TensorType(const(TF_Tensor)*) @nogc nothrow;
    void TF_DeleteTensor(TF_Tensor*) @nogc nothrow;
    TF_Tensor* TF_TensorMaybeMove(TF_Tensor*) @nogc nothrow;
    TF_Tensor* TF_AllocateTensor(TF_DataType, const(long)*, int, ulong) @nogc nothrow;
    TF_Tensor* TF_NewTensor(TF_DataType, const(long)*, int, void*, ulong, void function(void*, ulong, void*), void*) @nogc nothrow;
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
    ulong TF_DataTypeSize(TF_DataType) @nogc nothrow;
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
    void TF_RegisterLogListener(void function(const(char)*)) @nogc nothrow;
    void TF_DeleteServer(TF_Server*) @nogc nothrow;
    const(char)* TF_ServerTarget(TF_Server*) @nogc nothrow;
    void TF_ServerJoin(TF_Server*, TF_Status*) @nogc nothrow;
    void TF_ServerStop(TF_Server*, TF_Status*) @nogc nothrow;
    void TF_ServerStart(TF_Server*, TF_Status*) @nogc nothrow;
    TF_Server* TF_NewServer(const(void)*, ulong, TF_Status*) @nogc nothrow;
    struct TF_Server;
    TF_Buffer* TF_GetRegisteredKernelsForOp(const(char)*, TF_Status*) @nogc nothrow;
    TF_Buffer* TF_GetAllRegisteredKernels(TF_Status*) @nogc nothrow;
    TF_Buffer* TF_ApiDefMapGet(TF_ApiDefMap*, const(char)*, ulong, TF_Status*) @nogc nothrow;
    void TF_ApiDefMapPut(TF_ApiDefMap*, const(char)*, ulong, TF_Status*) @nogc nothrow;
    void TF_DeleteApiDefMap(TF_ApiDefMap*) @nogc nothrow;
    TF_ApiDefMap* TF_NewApiDefMap(TF_Buffer*, TF_Status*) @nogc nothrow;
    struct TF_ApiDefMap;
    TF_Buffer* TF_GetAllOpList() @nogc nothrow;
    void TF_DeleteLibraryHandle(TF_Library*) @nogc nothrow;
    TF_Buffer TF_GetOpList(TF_Library*) @nogc nothrow;
    TF_Library* TF_LoadLibrary(const(char)*, TF_Status*) @nogc nothrow;
    struct TF_Library;
    ulong TF_DeviceListIncarnation(const(TF_DeviceList)*, int, TF_Status*) @nogc nothrow;
    long TF_DeviceListMemoryBytes(const(TF_DeviceList)*, int, TF_Status*) @nogc nothrow;
    const(char)* TF_DeviceListType(const(TF_DeviceList)*, int, TF_Status*) @nogc nothrow;
    const(char)* TF_DeviceListName(const(TF_DeviceList)*, int, TF_Status*) @nogc nothrow;
    int TF_DeviceListCount(const(TF_DeviceList)*) @nogc nothrow;
    void TF_DeleteDeviceList(TF_DeviceList*) @nogc nothrow;
    TF_DeviceList* TF_DeprecatedSessionListDevices(TF_DeprecatedSession*, TF_Status*) @nogc nothrow;
    TF_DeviceList* TF_SessionListDevices(TF_Session*, TF_Status*) @nogc nothrow;
    struct TF_DeviceList;
    void TF_PRun(TF_DeprecatedSession*, const(char)*, const(char)**, TF_Tensor**, int, const(char)**, TF_Tensor**, int, const(char)**, int, TF_Status*) @nogc nothrow;
    void TF_PRunSetup(TF_DeprecatedSession*, const(char)**, int, const(char)**, int, const(char)**, int, const(char)**, TF_Status*) @nogc nothrow;
    void TF_Run(TF_DeprecatedSession*, const(TF_Buffer)*, const(char)**, TF_Tensor**, int, const(char)**, TF_Tensor**, int, const(char)**, int, TF_Buffer*, TF_Status*) @nogc nothrow;
    void TF_ExtendGraph(TF_DeprecatedSession*, const(void)*, ulong, TF_Status*) @nogc nothrow;
    void TF_Reset(const(TF_SessionOptions)*, const(char)**, int, TF_Status*) @nogc nothrow;
    void TF_DeleteDeprecatedSession(TF_DeprecatedSession*, TF_Status*) @nogc nothrow;
    void TF_CloseDeprecatedSession(TF_DeprecatedSession*, TF_Status*) @nogc nothrow;
    TF_DeprecatedSession* TF_NewDeprecatedSession(const(TF_SessionOptions)*, TF_Status*) @nogc nothrow;
    struct TF_DeprecatedSession;
    void TF_DeletePRunHandle(const(char)*) @nogc nothrow;
    void TF_SessionPRun(TF_Session*, const(char)*, const(TF_Output)*, TF_Tensor**, int, const(TF_Output)*, TF_Tensor**, int, const(const(TF_Operation)*)*, int, TF_Status*) @nogc nothrow;
    void TF_SessionPRunSetup(TF_Session*, const(TF_Output)*, int, const(TF_Output)*, int, const(const(TF_Operation)*)*, int, const(char)**, TF_Status*) @nogc nothrow;
    void TF_SessionRun(TF_Session*, const(TF_Buffer)*, const(TF_Output)*, TF_Tensor**, int, const(TF_Output)*, TF_Tensor**, int, const(const(TF_Operation)*)*, int, TF_Buffer*, TF_Status*) @nogc nothrow;
    void TF_DeleteSession(TF_Session*, TF_Status*) @nogc nothrow;
    void TF_CloseSession(TF_Session*, TF_Status*) @nogc nothrow;
    TF_Session* TF_LoadSessionFromSavedModel(const(TF_SessionOptions)*, const(TF_Buffer)*, const(char)*, const(const(char)*)*, int, TF_Graph*, TF_Buffer*, TF_Status*) @nogc nothrow;
    TF_Session* TF_NewSession(TF_Graph*, const(TF_SessionOptions)*, TF_Status*) @nogc nothrow;
    struct TF_Session;
    ubyte TF_TryEvaluateConstant(TF_Graph*, TF_Output, TF_Tensor**, TF_Status*) @nogc nothrow;
    void TF_DeleteFunction(TF_Function*) @nogc nothrow;
    void TF_FunctionGetAttrValueProto(TF_Function*, const(char)*, TF_Buffer*, TF_Status*) @nogc nothrow;
    void TF_FunctionSetAttrValueProto(TF_Function*, const(char)*, const(void)*, ulong, TF_Status*) @nogc nothrow;
    TF_Function* TF_FunctionImportFunctionDef(const(void)*, ulong, TF_Status*) @nogc nothrow;
    void TF_FunctionToFunctionDef(TF_Function*, TF_Buffer*, TF_Status*) @nogc nothrow;
    const(char)* TF_FunctionName(TF_Function*) @nogc nothrow;
    TF_Function* TF_GraphToFunctionWithControlOutputs(const(TF_Graph)*, const(char)*, ubyte, int, const(const(TF_Operation)*)*, int, const(TF_Output)*, int, const(TF_Output)*, const(const(char)*)*, int, const(const(TF_Operation)*)*, const(const(char)*)*, const(TF_FunctionOptions)*, const(char)*, TF_Status*) @nogc nothrow;
    TF_Function* TF_GraphToFunction(const(TF_Graph)*, const(char)*, ubyte, int, const(const(TF_Operation)*)*, int, const(TF_Output)*, int, const(TF_Output)*, const(const(char)*)*, const(TF_FunctionOptions)*, const(char)*, TF_Status*) @nogc nothrow;
    void TF_AddGradientsWithPrefix(TF_Graph*, const(char)*, TF_Output*, int, TF_Output*, int, TF_Output*, TF_Status*, TF_Output*) @nogc nothrow;
    void TF_AddGradients(TF_Graph*, TF_Output*, int, TF_Output*, int, TF_Output*, TF_Status*, TF_Output*) @nogc nothrow;
    void TF_AbortWhile(const(TF_WhileParams)*) @nogc nothrow;
    void TF_FinishWhile(const(TF_WhileParams)*, TF_Status*, TF_Output*) @nogc nothrow;
    TF_WhileParams TF_NewWhile(TF_Graph*, TF_Output*, int, TF_Status*) @nogc nothrow;
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
    void TF_OperationToNodeDef(TF_Operation*, TF_Buffer*, TF_Status*) @nogc nothrow;
    int TF_GraphGetFunctions(TF_Graph*, TF_Function**, int, TF_Status*) @nogc nothrow;
    int TF_GraphNumFunctions(TF_Graph*) @nogc nothrow;
    void TF_GraphCopyFunction(TF_Graph*, const(TF_Function)*, const(TF_Function)*, TF_Status*) @nogc nothrow;
    void TF_GraphImportGraphDef(TF_Graph*, const(TF_Buffer)*, const(TF_ImportGraphDefOptions)*, TF_Status*) @nogc nothrow;
    void TF_GraphImportGraphDefWithReturnOutputs(TF_Graph*, const(TF_Buffer)*, const(TF_ImportGraphDefOptions)*, TF_Output*, int, TF_Status*) @nogc nothrow;
    TF_ImportGraphDefResults* TF_GraphImportGraphDefWithResults(TF_Graph*, const(TF_Buffer)*, const(TF_ImportGraphDefOptions)*, TF_Status*) @nogc nothrow;
    void TF_DeleteImportGraphDefResults(TF_ImportGraphDefResults*) @nogc nothrow;
    void TF_ImportGraphDefResultsMissingUnusedInputMappings(TF_ImportGraphDefResults*, int*, const(char)***, int**) @nogc nothrow;
    void TF_ImportGraphDefResultsReturnOperations(TF_ImportGraphDefResults*, int*, TF_Operation***) @nogc nothrow;
    void TF_ImportGraphDefResultsReturnOutputs(TF_ImportGraphDefResults*, int*, TF_Output**) @nogc nothrow;
    struct TF_ImportGraphDefResults;
    int TF_ImportGraphDefOptionsNumReturnOperations(const(TF_ImportGraphDefOptions)*) @nogc nothrow;
    void TF_ImportGraphDefOptionsAddReturnOperation(TF_ImportGraphDefOptions*, const(char)*) @nogc nothrow;
    int TF_ImportGraphDefOptionsNumReturnOutputs(const(TF_ImportGraphDefOptions)*) @nogc nothrow;
    void TF_ImportGraphDefOptionsAddReturnOutput(TF_ImportGraphDefOptions*, const(char)*, int) @nogc nothrow;
    void TF_ImportGraphDefOptionsAddControlDependency(TF_ImportGraphDefOptions*, TF_Operation*) @nogc nothrow;
    void TF_ImportGraphDefOptionsRemapControlDependency(TF_ImportGraphDefOptions*, const(char)*, TF_Operation*) @nogc nothrow;
    void TF_ImportGraphDefOptionsAddInputMapping(TF_ImportGraphDefOptions*, const(char)*, int, TF_Output) @nogc nothrow;
    void TF_ImportGraphDefOptionsSetUniquifyPrefix(TF_ImportGraphDefOptions*, ubyte) @nogc nothrow;
    void TF_ImportGraphDefOptionsSetUniquifyNames(TF_ImportGraphDefOptions*, ubyte) @nogc nothrow;
    void TF_ImportGraphDefOptionsSetDefaultDevice(TF_ImportGraphDefOptions*, const(char)*) @nogc nothrow;
    void TF_ImportGraphDefOptionsSetPrefix(TF_ImportGraphDefOptions*, const(char)*) @nogc nothrow;
    void TF_DeleteImportGraphDefOptions(TF_ImportGraphDefOptions*) @nogc nothrow;
    TF_ImportGraphDefOptions* TF_NewImportGraphDefOptions() @nogc nothrow;
    struct TF_ImportGraphDefOptions;
    void TF_GraphVersions(TF_Graph*, TF_Buffer*, TF_Status*) @nogc nothrow;
    void TF_GraphGetOpDef(TF_Graph*, const(char)*, TF_Buffer*, TF_Status*) @nogc nothrow;
    void TF_GraphToGraphDef(TF_Graph*, TF_Buffer*, TF_Status*) @nogc nothrow;
    TF_Operation* TF_GraphNextOperation(TF_Graph*, ulong*) @nogc nothrow;
    TF_Operation* TF_GraphOperationByName(TF_Graph*, const(char)*) @nogc nothrow;
    void TF_OperationGetAttrValueProto(TF_Operation*, const(char)*, TF_Buffer*, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrTensorList(TF_Operation*, const(char)*, TF_Tensor**, int, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrTensor(TF_Operation*, const(char)*, TF_Tensor**, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrTensorShapeProtoList(TF_Operation*, const(char)*, TF_Buffer**, int, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrTensorShapeProto(TF_Operation*, const(char)*, TF_Buffer*, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrShapeList(TF_Operation*, const(char)*, long**, int*, int, long*, int, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrShape(TF_Operation*, const(char)*, long*, int, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrTypeList(TF_Operation*, const(char)*, TF_DataType*, int, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrType(TF_Operation*, const(char)*, TF_DataType*, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrBoolList(TF_Operation*, const(char)*, ubyte*, int, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrBool(TF_Operation*, const(char)*, ubyte*, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrFloatList(TF_Operation*, const(char)*, float*, int, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrFloat(TF_Operation*, const(char)*, float*, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrIntList(TF_Operation*, const(char)*, long*, int, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrInt(TF_Operation*, const(char)*, long*, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrStringList(TF_Operation*, const(char)*, void**, ulong*, int, void*, ulong, TF_Status*) @nogc nothrow;
    void TF_OperationGetAttrString(TF_Operation*, const(char)*, void*, ulong, TF_Status*) @nogc nothrow;
    TF_AttrMetadata TF_OperationGetAttrMetadata(TF_Operation*, const(char)*, TF_Status*) @nogc nothrow;
    struct TF_AttrMetadata
    {
        ubyte is_list;
        long list_size;
        TF_AttrType type;
        long total_size;
    }
    int TF_OperationGetControlOutputs(TF_Operation*, TF_Operation**, int) @nogc nothrow;
    int TF_OperationNumControlOutputs(TF_Operation*) @nogc nothrow;
    int TF_OperationGetControlInputs(TF_Operation*, TF_Operation**, int) @nogc nothrow;
    int TF_OperationNumControlInputs(TF_Operation*) @nogc nothrow;
    int TF_OperationOutputConsumers(TF_Output, TF_Input*, int) @nogc nothrow;
    int TF_OperationOutputNumConsumers(TF_Output) @nogc nothrow;
    TF_Output TF_OperationInput(TF_Input) @nogc nothrow;
    int TF_OperationInputListLength(TF_Operation*, const(char)*, TF_Status*) @nogc nothrow;
    TF_DataType TF_OperationInputType(TF_Input) @nogc nothrow;
    int TF_OperationNumInputs(TF_Operation*) @nogc nothrow;
    int TF_OperationOutputListLength(TF_Operation*, const(char)*, TF_Status*) @nogc nothrow;
    TF_DataType TF_OperationOutputType(TF_Output) @nogc nothrow;
    int TF_OperationNumOutputs(TF_Operation*) @nogc nothrow;
    const(char)* TF_OperationDevice(TF_Operation*) @nogc nothrow;
    const(char)* TF_OperationOpType(TF_Operation*) @nogc nothrow;
    const(char)* TF_OperationName(TF_Operation*) @nogc nothrow;
    TF_Operation* TF_FinishOperation(TF_OperationDescription*, TF_Status*) @nogc nothrow;
    void TF_SetAttrValueProto(TF_OperationDescription*, const(char)*, const(void)*, ulong, TF_Status*) @nogc nothrow;
    void TF_SetAttrTensorList(TF_OperationDescription*, const(char)*, TF_Tensor**, int, TF_Status*) @nogc nothrow;
    void TF_SetAttrTensor(TF_OperationDescription*, const(char)*, TF_Tensor*, TF_Status*) @nogc nothrow;
    void TF_SetAttrTensorShapeProtoList(TF_OperationDescription*, const(char)*, const(const(void)*)*, const(ulong)*, int, TF_Status*) @nogc nothrow;
    void TF_SetAttrTensorShapeProto(TF_OperationDescription*, const(char)*, const(void)*, ulong, TF_Status*) @nogc nothrow;
    void TF_SetAttrShapeList(TF_OperationDescription*, const(char)*, const(const(long)*)*, const(int)*, int) @nogc nothrow;
    alias max_align_t = double;
    void TF_SetAttrShape(TF_OperationDescription*, const(char)*, const(long)*, int) @nogc nothrow;
    void TF_SetAttrFuncName(TF_OperationDescription*, const(char)*, const(char)*, ulong) @nogc nothrow;
    void TF_SetAttrPlaceholder(TF_OperationDescription*, const(char)*, const(char)*) @nogc nothrow;
    void TF_SetAttrTypeList(TF_OperationDescription*, const(char)*, const(TF_DataType)*, int) @nogc nothrow;
    void TF_SetAttrType(TF_OperationDescription*, const(char)*, TF_DataType) @nogc nothrow;
    void TF_SetAttrBoolList(TF_OperationDescription*, const(char)*, const(ubyte)*, int) @nogc nothrow;
    void TF_SetAttrBool(TF_OperationDescription*, const(char)*, ubyte) @nogc nothrow;
    alias ptrdiff_t = long;
    void TF_SetAttrFloatList(TF_OperationDescription*, const(char)*, const(float)*, int) @nogc nothrow;
    alias wchar_t = ushort;
    void TF_SetAttrFloat(TF_OperationDescription*, const(char)*, float) @nogc nothrow;
    alias int64_t = long;
    alias uint64_t = ulong;
    void TF_SetAttrIntList(TF_OperationDescription*, const(char)*, const(long)*, int) @nogc nothrow;
    void TF_SetAttrInt(TF_OperationDescription*, const(char)*, long) @nogc nothrow;
    void TF_SetAttrStringList(TF_OperationDescription*, const(char)*, const(const(void)*)*, const(ulong)*, int) @nogc nothrow;
    void TF_SetAttrString(TF_OperationDescription*, const(char)*, const(void)*, ulong) @nogc nothrow;
    alias int_least64_t = long;
    alias uint_least64_t = ulong;
    alias int_fast64_t = long;
    alias uint_fast64_t = ulong;
    alias int32_t = int;
    void TF_ColocateWith(TF_OperationDescription*, TF_Operation*) @nogc nothrow;
    alias uint32_t = uint;
    void TF_AddControlInput(TF_OperationDescription*, TF_Operation*) @nogc nothrow;
    void TF_AddInputList(TF_OperationDescription*, const(TF_Output)*, int) @nogc nothrow;
    void TF_AddInput(TF_OperationDescription*, TF_Output) @nogc nothrow;
    alias int_least32_t = int;
    alias uint_least32_t = uint;
    alias int_fast32_t = int;
    alias uint_fast32_t = uint;
    alias int16_t = short;
    alias uint16_t = ushort;
    void TF_SetDevice(TF_OperationDescription*, const(char)*) @nogc nothrow;
    TF_OperationDescription* TF_NewOperation(TF_Graph*, const(char)*, const(char)*) @nogc nothrow;
    alias int_least16_t = short;
    alias uint_least16_t = ushort;
    alias int_fast16_t = short;
    alias uint_fast16_t = ushort;
    alias int8_t = byte;
    alias uint8_t = ubyte;
    void TF_GraphGetTensorShape(TF_Graph*, TF_Output, long*, int, TF_Status*) @nogc nothrow;
    alias int_least8_t = byte;
    alias uint_least8_t = ubyte;
    alias int_fast8_t = byte;
    alias uint_fast8_t = ubyte;
    int TF_GraphGetTensorNumDims(TF_Graph*, TF_Output, TF_Status*) @nogc nothrow;
    alias intptr_t = long;
    void TF_GraphSetTensorShape(TF_Graph*, TF_Output, const(long)*, const(int), TF_Status*) @nogc nothrow;
    alias uintptr_t = ulong;
    struct TF_FunctionOptions;
    alias intmax_t = long;
    alias uintmax_t = ulong;
    struct TF_Function;
    struct TF_Output
    {
        TF_Operation* oper;
        int index;
    }
    struct TF_Input
    {
        TF_Operation* oper;
        int index;
    }
    struct TF_Operation;
    struct TF_OperationDescription;
    void TF_DeleteGraph(TF_Graph*) @nogc nothrow;
    TF_Graph* TF_NewGraph() @nogc nothrow;
    struct TF_Graph;
    void TF_DeleteSessionOptions(TF_SessionOptions*) @nogc nothrow;
    void TF_SetConfig(TF_SessionOptions*, const(void)*, ulong, TF_Status*) @nogc nothrow;
    void TF_SetTarget(TF_SessionOptions*, const(char)*) @nogc nothrow;
    TF_SessionOptions* TF_NewSessionOptions() @nogc nothrow;
    struct TF_SessionOptions;
    TF_Buffer TF_GetBuffer(TF_Buffer*) @nogc nothrow;
    void TF_DeleteBuffer(TF_Buffer*) @nogc nothrow;
    TF_Buffer* TF_NewBuffer() @nogc nothrow;
    TF_Buffer* TF_NewBufferFromString(const(void)*, ulong) @nogc nothrow;
    struct TF_Buffer
    {
        const(void)* data;
        ulong length;
        void function(void*, ulong) data_deallocator;
    }
    const(char)* TF_Version() @nogc nothrow;



    static if(!is(typeof(INT_LEAST32_MIN))) {
        private enum enumMixinStr_INT_LEAST32_MIN = `enum INT_LEAST32_MIN = __INT_LEAST32_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST32_MIN); }))) {
            mixin(enumMixinStr_INT_LEAST32_MIN);
        }
    }




    static if(!is(typeof(INT_LEAST32_MAX))) {
        private enum enumMixinStr_INT_LEAST32_MAX = `enum INT_LEAST32_MAX = __INT_LEAST32_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST32_MAX); }))) {
            mixin(enumMixinStr_INT_LEAST32_MAX);
        }
    }




    static if(!is(typeof(UINT_LEAST32_MAX))) {
        private enum enumMixinStr_UINT_LEAST32_MAX = `enum UINT_LEAST32_MAX = __UINT_LEAST32_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_LEAST32_MAX); }))) {
            mixin(enumMixinStr_UINT_LEAST32_MAX);
        }
    }




    static if(!is(typeof(INT_FAST32_MIN))) {
        private enum enumMixinStr_INT_FAST32_MIN = `enum INT_FAST32_MIN = __INT_LEAST32_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST32_MIN); }))) {
            mixin(enumMixinStr_INT_FAST32_MIN);
        }
    }




    static if(!is(typeof(INT_FAST32_MAX))) {
        private enum enumMixinStr_INT_FAST32_MAX = `enum INT_FAST32_MAX = __INT_LEAST32_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST32_MAX); }))) {
            mixin(enumMixinStr_INT_FAST32_MAX);
        }
    }




    static if(!is(typeof(UINT_FAST32_MAX))) {
        private enum enumMixinStr_UINT_FAST32_MAX = `enum UINT_FAST32_MAX = __UINT_LEAST32_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_FAST32_MAX); }))) {
            mixin(enumMixinStr_UINT_FAST32_MAX);
        }
    }




    static if(!is(typeof(__UINT_LEAST8_MAX))) {
        private enum enumMixinStr___UINT_LEAST8_MAX = `enum __UINT_LEAST8_MAX = UINT32_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr___UINT_LEAST8_MAX); }))) {
            mixin(enumMixinStr___UINT_LEAST8_MAX);
        }
    }




    static if(!is(typeof(INT16_MAX))) {
        private enum enumMixinStr_INT16_MAX = `enum INT16_MAX = INT16_C ( 32767 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT16_MAX); }))) {
            mixin(enumMixinStr_INT16_MAX);
        }
    }




    static if(!is(typeof(INT16_MIN))) {
        private enum enumMixinStr_INT16_MIN = `enum INT16_MIN = ( - INT16_C ( 32767 ) - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT16_MIN); }))) {
            mixin(enumMixinStr_INT16_MIN);
        }
    }




    static if(!is(typeof(UINT16_MAX))) {
        private enum enumMixinStr_UINT16_MAX = `enum UINT16_MAX = UINT16_C ( 65535 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT16_MAX); }))) {
            mixin(enumMixinStr_UINT16_MAX);
        }
    }




    static if(!is(typeof(__INT_LEAST16_MIN))) {
        private enum enumMixinStr___INT_LEAST16_MIN = `enum __INT_LEAST16_MIN = ( - INT16_C ( 32767 ) - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr___INT_LEAST16_MIN); }))) {
            mixin(enumMixinStr___INT_LEAST16_MIN);
        }
    }




    static if(!is(typeof(__INT_LEAST16_MAX))) {
        private enum enumMixinStr___INT_LEAST16_MAX = `enum __INT_LEAST16_MAX = INT16_C ( 32767 );`;
        static if(is(typeof({ mixin(enumMixinStr___INT_LEAST16_MAX); }))) {
            mixin(enumMixinStr___INT_LEAST16_MAX);
        }
    }




    static if(!is(typeof(__UINT_LEAST16_MAX))) {
        private enum enumMixinStr___UINT_LEAST16_MAX = `enum __UINT_LEAST16_MAX = UINT16_C ( 65535 );`;
        static if(is(typeof({ mixin(enumMixinStr___UINT_LEAST16_MAX); }))) {
            mixin(enumMixinStr___UINT_LEAST16_MAX);
        }
    }




    static if(!is(typeof(__INT_LEAST8_MIN))) {
        private enum enumMixinStr___INT_LEAST8_MIN = `enum __INT_LEAST8_MIN = ( - INT16_C ( 32767 ) - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr___INT_LEAST8_MIN); }))) {
            mixin(enumMixinStr___INT_LEAST8_MIN);
        }
    }




    static if(!is(typeof(__INT_LEAST8_MAX))) {
        private enum enumMixinStr___INT_LEAST8_MAX = `enum __INT_LEAST8_MAX = INT16_C ( 32767 );`;
        static if(is(typeof({ mixin(enumMixinStr___INT_LEAST8_MAX); }))) {
            mixin(enumMixinStr___INT_LEAST8_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST16_MIN))) {
        private enum enumMixinStr_INT_LEAST16_MIN = `enum INT_LEAST16_MIN = ( - INT16_C ( 32767 ) - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST16_MIN); }))) {
            mixin(enumMixinStr_INT_LEAST16_MIN);
        }
    }




    static if(!is(typeof(INT_LEAST16_MAX))) {
        private enum enumMixinStr_INT_LEAST16_MAX = `enum INT_LEAST16_MAX = INT16_C ( 32767 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST16_MAX); }))) {
            mixin(enumMixinStr_INT_LEAST16_MAX);
        }
    }




    static if(!is(typeof(UINT_LEAST16_MAX))) {
        private enum enumMixinStr_UINT_LEAST16_MAX = `enum UINT_LEAST16_MAX = UINT16_C ( 65535 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_LEAST16_MAX); }))) {
            mixin(enumMixinStr_UINT_LEAST16_MAX);
        }
    }




    static if(!is(typeof(INT_FAST16_MIN))) {
        private enum enumMixinStr_INT_FAST16_MIN = `enum INT_FAST16_MIN = ( - INT16_C ( 32767 ) - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST16_MIN); }))) {
            mixin(enumMixinStr_INT_FAST16_MIN);
        }
    }




    static if(!is(typeof(INT_FAST16_MAX))) {
        private enum enumMixinStr_INT_FAST16_MAX = `enum INT_FAST16_MAX = INT16_C ( 32767 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST16_MAX); }))) {
            mixin(enumMixinStr_INT_FAST16_MAX);
        }
    }




    static if(!is(typeof(UINT_FAST16_MAX))) {
        private enum enumMixinStr_UINT_FAST16_MAX = `enum UINT_FAST16_MAX = UINT16_C ( 65535 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_FAST16_MAX); }))) {
            mixin(enumMixinStr_UINT_FAST16_MAX);
        }
    }




    static if(!is(typeof(INT8_MAX))) {
        private enum enumMixinStr_INT8_MAX = `enum INT8_MAX = INT8_C ( 127 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT8_MAX); }))) {
            mixin(enumMixinStr_INT8_MAX);
        }
    }




    static if(!is(typeof(INT8_MIN))) {
        private enum enumMixinStr_INT8_MIN = `enum INT8_MIN = ( - INT8_C ( 127 ) - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT8_MIN); }))) {
            mixin(enumMixinStr_INT8_MIN);
        }
    }




    static if(!is(typeof(UINT8_MAX))) {
        private enum enumMixinStr_UINT8_MAX = `enum UINT8_MAX = UINT8_C ( 255 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT8_MAX); }))) {
            mixin(enumMixinStr_UINT8_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST8_MIN))) {
        private enum enumMixinStr_INT_LEAST8_MIN = `enum INT_LEAST8_MIN = ( - INT16_C ( 32767 ) - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST8_MIN); }))) {
            mixin(enumMixinStr_INT_LEAST8_MIN);
        }
    }




    static if(!is(typeof(INT_LEAST8_MAX))) {
        private enum enumMixinStr_INT_LEAST8_MAX = `enum INT_LEAST8_MAX = INT16_C ( 32767 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST8_MAX); }))) {
            mixin(enumMixinStr_INT_LEAST8_MAX);
        }
    }




    static if(!is(typeof(UINT_LEAST8_MAX))) {
        private enum enumMixinStr_UINT_LEAST8_MAX = `enum UINT_LEAST8_MAX = UINT32_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_LEAST8_MAX); }))) {
            mixin(enumMixinStr_UINT_LEAST8_MAX);
        }
    }




    static if(!is(typeof(INT_FAST8_MIN))) {
        private enum enumMixinStr_INT_FAST8_MIN = `enum INT_FAST8_MIN = ( - INT16_C ( 32767 ) - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST8_MIN); }))) {
            mixin(enumMixinStr_INT_FAST8_MIN);
        }
    }




    static if(!is(typeof(INT_FAST8_MAX))) {
        private enum enumMixinStr_INT_FAST8_MAX = `enum INT_FAST8_MAX = INT16_C ( 32767 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST8_MAX); }))) {
            mixin(enumMixinStr_INT_FAST8_MAX);
        }
    }




    static if(!is(typeof(UINT_FAST8_MAX))) {
        private enum enumMixinStr_UINT_FAST8_MAX = `enum UINT_FAST8_MAX = UINT32_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_FAST8_MAX); }))) {
            mixin(enumMixinStr_UINT_FAST8_MAX);
        }
    }
    static if(!is(typeof(INTPTR_MIN))) {
        private enum enumMixinStr_INTPTR_MIN = `enum INTPTR_MIN = ( - 9223372036854775807LL - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INTPTR_MIN); }))) {
            mixin(enumMixinStr_INTPTR_MIN);
        }
    }




    static if(!is(typeof(INTPTR_MAX))) {
        private enum enumMixinStr_INTPTR_MAX = `enum INTPTR_MAX = 9223372036854775807LL;`;
        static if(is(typeof({ mixin(enumMixinStr_INTPTR_MAX); }))) {
            mixin(enumMixinStr_INTPTR_MAX);
        }
    }




    static if(!is(typeof(UINTPTR_MAX))) {
        private enum enumMixinStr_UINTPTR_MAX = `enum UINTPTR_MAX = 18446744073709551615ULL;`;
        static if(is(typeof({ mixin(enumMixinStr_UINTPTR_MAX); }))) {
            mixin(enumMixinStr_UINTPTR_MAX);
        }
    }




    static if(!is(typeof(PTRDIFF_MIN))) {
        private enum enumMixinStr_PTRDIFF_MIN = `enum PTRDIFF_MIN = ( - 9223372036854775807LL - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_PTRDIFF_MIN); }))) {
            mixin(enumMixinStr_PTRDIFF_MIN);
        }
    }




    static if(!is(typeof(PTRDIFF_MAX))) {
        private enum enumMixinStr_PTRDIFF_MAX = `enum PTRDIFF_MAX = 9223372036854775807LL;`;
        static if(is(typeof({ mixin(enumMixinStr_PTRDIFF_MAX); }))) {
            mixin(enumMixinStr_PTRDIFF_MAX);
        }
    }




    static if(!is(typeof(SIZE_MAX))) {
        private enum enumMixinStr_SIZE_MAX = `enum SIZE_MAX = 18446744073709551615ULL;`;
        static if(is(typeof({ mixin(enumMixinStr_SIZE_MAX); }))) {
            mixin(enumMixinStr_SIZE_MAX);
        }
    }




    static if(!is(typeof(INTMAX_MIN))) {
        private enum enumMixinStr_INTMAX_MIN = `enum INTMAX_MIN = ( - 9223372036854775807LL - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INTMAX_MIN); }))) {
            mixin(enumMixinStr_INTMAX_MIN);
        }
    }




    static if(!is(typeof(INTMAX_MAX))) {
        private enum enumMixinStr_INTMAX_MAX = `enum INTMAX_MAX = 9223372036854775807LL;`;
        static if(is(typeof({ mixin(enumMixinStr_INTMAX_MAX); }))) {
            mixin(enumMixinStr_INTMAX_MAX);
        }
    }




    static if(!is(typeof(UINTMAX_MAX))) {
        private enum enumMixinStr_UINTMAX_MAX = `enum UINTMAX_MAX = 18446744073709551615ULL;`;
        static if(is(typeof({ mixin(enumMixinStr_UINTMAX_MAX); }))) {
            mixin(enumMixinStr_UINTMAX_MAX);
        }
    }




    static if(!is(typeof(SIG_ATOMIC_MIN))) {
        private enum enumMixinStr_SIG_ATOMIC_MIN = `enum SIG_ATOMIC_MIN = __stdint_join3 ( INT , 32 , _MIN );`;
        static if(is(typeof({ mixin(enumMixinStr_SIG_ATOMIC_MIN); }))) {
            mixin(enumMixinStr_SIG_ATOMIC_MIN);
        }
    }




    static if(!is(typeof(SIG_ATOMIC_MAX))) {
        private enum enumMixinStr_SIG_ATOMIC_MAX = `enum SIG_ATOMIC_MAX = __stdint_join3 ( INT , 32 , _MAX );`;
        static if(is(typeof({ mixin(enumMixinStr_SIG_ATOMIC_MAX); }))) {
            mixin(enumMixinStr_SIG_ATOMIC_MAX);
        }
    }




    static if(!is(typeof(WINT_MIN))) {
        private enum enumMixinStr_WINT_MIN = `enum WINT_MIN = __stdint_join3 ( INT , 32 , _MIN );`;
        static if(is(typeof({ mixin(enumMixinStr_WINT_MIN); }))) {
            mixin(enumMixinStr_WINT_MIN);
        }
    }




    static if(!is(typeof(WINT_MAX))) {
        private enum enumMixinStr_WINT_MAX = `enum WINT_MAX = __stdint_join3 ( INT , 32 , _MAX );`;
        static if(is(typeof({ mixin(enumMixinStr_WINT_MAX); }))) {
            mixin(enumMixinStr_WINT_MAX);
        }
    }




    static if(!is(typeof(WCHAR_MAX))) {
        private enum enumMixinStr_WCHAR_MAX = `enum WCHAR_MAX = 65535;`;
        static if(is(typeof({ mixin(enumMixinStr_WCHAR_MAX); }))) {
            mixin(enumMixinStr_WCHAR_MAX);
        }
    }




    static if(!is(typeof(__UINT_LEAST32_MAX))) {
        private enum enumMixinStr___UINT_LEAST32_MAX = `enum __UINT_LEAST32_MAX = UINT32_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr___UINT_LEAST32_MAX); }))) {
            mixin(enumMixinStr___UINT_LEAST32_MAX);
        }
    }




    static if(!is(typeof(WCHAR_MIN))) {
        private enum enumMixinStr_WCHAR_MIN = `enum WCHAR_MIN = __stdint_join3 ( UINT , 16 , _C ( 0 ) );`;
        static if(is(typeof({ mixin(enumMixinStr_WCHAR_MIN); }))) {
            mixin(enumMixinStr_WCHAR_MIN);
        }
    }
    static if(!is(typeof(__INT_LEAST32_MAX))) {
        private enum enumMixinStr___INT_LEAST32_MAX = `enum __INT_LEAST32_MAX = INT32_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr___INT_LEAST32_MAX); }))) {
            mixin(enumMixinStr___INT_LEAST32_MAX);
        }
    }






    static if(!is(typeof(__INT_LEAST32_MIN))) {
        private enum enumMixinStr___INT_LEAST32_MIN = `enum __INT_LEAST32_MIN = INT32_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr___INT_LEAST32_MIN); }))) {
            mixin(enumMixinStr___INT_LEAST32_MIN);
        }
    }




    static if(!is(typeof(UINT32_MAX))) {
        private enum enumMixinStr_UINT32_MAX = `enum UINT32_MAX = UINT32_C ( 4294967295 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT32_MAX); }))) {
            mixin(enumMixinStr_UINT32_MAX);
        }
    }




    static if(!is(typeof(INT32_MIN))) {
        private enum enumMixinStr_INT32_MIN = `enum INT32_MIN = ( - INT32_C ( 2147483647 ) - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT32_MIN); }))) {
            mixin(enumMixinStr_INT32_MIN);
        }
    }




    static if(!is(typeof(INT32_MAX))) {
        private enum enumMixinStr_INT32_MAX = `enum INT32_MAX = INT32_C ( 2147483647 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT32_MAX); }))) {
            mixin(enumMixinStr_INT32_MAX);
        }
    }




    static if(!is(typeof(UINT_FAST64_MAX))) {
        private enum enumMixinStr_UINT_FAST64_MAX = `enum UINT_FAST64_MAX = __UINT_LEAST64_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_FAST64_MAX); }))) {
            mixin(enumMixinStr_UINT_FAST64_MAX);
        }
    }




    static if(!is(typeof(INT_FAST64_MAX))) {
        private enum enumMixinStr_INT_FAST64_MAX = `enum INT_FAST64_MAX = __INT_LEAST64_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST64_MAX); }))) {
            mixin(enumMixinStr_INT_FAST64_MAX);
        }
    }




    static if(!is(typeof(INT_FAST64_MIN))) {
        private enum enumMixinStr_INT_FAST64_MIN = `enum INT_FAST64_MIN = __INT_LEAST64_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST64_MIN); }))) {
            mixin(enumMixinStr_INT_FAST64_MIN);
        }
    }




    static if(!is(typeof(TF_CAPI_EXPORT))) {
        private enum enumMixinStr_TF_CAPI_EXPORT = `enum TF_CAPI_EXPORT = __declspec ( dllimport );`;
        static if(is(typeof({ mixin(enumMixinStr_TF_CAPI_EXPORT); }))) {
            mixin(enumMixinStr_TF_CAPI_EXPORT);
        }
    }




    static if(!is(typeof(UINT_LEAST64_MAX))) {
        private enum enumMixinStr_UINT_LEAST64_MAX = `enum UINT_LEAST64_MAX = __UINT_LEAST64_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_LEAST64_MAX); }))) {
            mixin(enumMixinStr_UINT_LEAST64_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST64_MAX))) {
        private enum enumMixinStr_INT_LEAST64_MAX = `enum INT_LEAST64_MAX = __INT_LEAST64_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST64_MAX); }))) {
            mixin(enumMixinStr_INT_LEAST64_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST64_MIN))) {
        private enum enumMixinStr_INT_LEAST64_MIN = `enum INT_LEAST64_MIN = __INT_LEAST64_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST64_MIN); }))) {
            mixin(enumMixinStr_INT_LEAST64_MIN);
        }
    }




    static if(!is(typeof(__UINT_LEAST64_MAX))) {
        private enum enumMixinStr___UINT_LEAST64_MAX = `enum __UINT_LEAST64_MAX = UINT64_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr___UINT_LEAST64_MAX); }))) {
            mixin(enumMixinStr___UINT_LEAST64_MAX);
        }
    }




    static if(!is(typeof(__INT_LEAST64_MAX))) {
        private enum enumMixinStr___INT_LEAST64_MAX = `enum __INT_LEAST64_MAX = INT64_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr___INT_LEAST64_MAX); }))) {
            mixin(enumMixinStr___INT_LEAST64_MAX);
        }
    }




    static if(!is(typeof(__INT_LEAST64_MIN))) {
        private enum enumMixinStr___INT_LEAST64_MIN = `enum __INT_LEAST64_MIN = INT64_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr___INT_LEAST64_MIN); }))) {
            mixin(enumMixinStr___INT_LEAST64_MIN);
        }
    }




    static if(!is(typeof(UINT64_MAX))) {
        private enum enumMixinStr_UINT64_MAX = `enum UINT64_MAX = UINT64_C ( 18446744073709551615 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT64_MAX); }))) {
            mixin(enumMixinStr_UINT64_MAX);
        }
    }




    static if(!is(typeof(INT64_MIN))) {
        private enum enumMixinStr_INT64_MIN = `enum INT64_MIN = ( - INT64_C ( 9223372036854775807 ) - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT64_MIN); }))) {
            mixin(enumMixinStr_INT64_MIN);
        }
    }




    static if(!is(typeof(INT64_MAX))) {
        private enum enumMixinStr_INT64_MAX = `enum INT64_MAX = INT64_C ( 9223372036854775807 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT64_MAX); }))) {
            mixin(enumMixinStr_INT64_MAX);
        }
    }
    static if(!is(typeof(__int8_c_suffix))) {
        private enum enumMixinStr___int8_c_suffix = `enum __int8_c_suffix = ;`;
        static if(is(typeof({ mixin(enumMixinStr___int8_c_suffix); }))) {
            mixin(enumMixinStr___int8_c_suffix);
        }
    }
    static if(!is(typeof(__int16_c_suffix))) {
        private enum enumMixinStr___int16_c_suffix = `enum __int16_c_suffix = ;`;
        static if(is(typeof({ mixin(enumMixinStr___int16_c_suffix); }))) {
            mixin(enumMixinStr___int16_c_suffix);
        }
    }
    static if(!is(typeof(__int32_c_suffix))) {
        private enum enumMixinStr___int32_c_suffix = `enum __int32_c_suffix = ;`;
        static if(is(typeof({ mixin(enumMixinStr___int32_c_suffix); }))) {
            mixin(enumMixinStr___int32_c_suffix);
        }
    }
    static if(!is(typeof(__int64_c_suffix))) {
        private enum enumMixinStr___int64_c_suffix = `enum __int64_c_suffix = LL;`;
        static if(is(typeof({ mixin(enumMixinStr___int64_c_suffix); }))) {
            mixin(enumMixinStr___int64_c_suffix);
        }
    }
    static if(!is(typeof(__uint_least8_t))) {
        private enum enumMixinStr___uint_least8_t = `enum __uint_least8_t = uint8_t;`;
        static if(is(typeof({ mixin(enumMixinStr___uint_least8_t); }))) {
            mixin(enumMixinStr___uint_least8_t);
        }
    }




    static if(!is(typeof(__int_least8_t))) {
        private enum enumMixinStr___int_least8_t = `enum __int_least8_t = int8_t;`;
        static if(is(typeof({ mixin(enumMixinStr___int_least8_t); }))) {
            mixin(enumMixinStr___int_least8_t);
        }
    }




    static if(!is(typeof(__uint_least16_t))) {
        private enum enumMixinStr___uint_least16_t = `enum __uint_least16_t = uint16_t;`;
        static if(is(typeof({ mixin(enumMixinStr___uint_least16_t); }))) {
            mixin(enumMixinStr___uint_least16_t);
        }
    }




    static if(!is(typeof(__int_least16_t))) {
        private enum enumMixinStr___int_least16_t = `enum __int_least16_t = int16_t;`;
        static if(is(typeof({ mixin(enumMixinStr___int_least16_t); }))) {
            mixin(enumMixinStr___int_least16_t);
        }
    }




    static if(!is(typeof(__uint_least32_t))) {
        private enum enumMixinStr___uint_least32_t = `enum __uint_least32_t = uint32_t;`;
        static if(is(typeof({ mixin(enumMixinStr___uint_least32_t); }))) {
            mixin(enumMixinStr___uint_least32_t);
        }
    }




    static if(!is(typeof(__int_least32_t))) {
        private enum enumMixinStr___int_least32_t = `enum __int_least32_t = int32_t;`;
        static if(is(typeof({ mixin(enumMixinStr___int_least32_t); }))) {
            mixin(enumMixinStr___int_least32_t);
        }
    }






    static if(!is(typeof(__uint_least64_t))) {
        private enum enumMixinStr___uint_least64_t = `enum __uint_least64_t = uint64_t;`;
        static if(is(typeof({ mixin(enumMixinStr___uint_least64_t); }))) {
            mixin(enumMixinStr___uint_least64_t);
        }
    }




    static if(!is(typeof(__int_least64_t))) {
        private enum enumMixinStr___int_least64_t = `enum __int_least64_t = int64_t;`;
        static if(is(typeof({ mixin(enumMixinStr___int_least64_t); }))) {
            mixin(enumMixinStr___int_least64_t);
        }
    }
    static if(!is(typeof(NULL))) {
        private enum enumMixinStr_NULL = `enum NULL = ( cast( void * ) 0 );`;
        static if(is(typeof({ mixin(enumMixinStr_NULL); }))) {
            mixin(enumMixinStr_NULL);
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
}



version (Windows):
