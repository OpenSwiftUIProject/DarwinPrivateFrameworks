//
//  AGGraph.h
//  AttributeGraph

#ifndef AGGraph_h
#define AGGraph_h

#include <AttributeGraph/AGBase.h>
#include <AttributeGraph/Private/CFRuntime.h>
#include <AttributeGraph/AGCounterQueryType.h>

// Note: Place all structure declaration in a single place to avoid header cycle dependency

typedef struct AG_BRIDGED_TYPE(id) AGGraphStorage * AGGraphRef AG_SWIFT_NAME(Graph);
typedef struct AG_BRIDGED_TYPE(id) AGSubgraphStorage * AGSubgraphRef AG_SWIFT_NAME(Subgraph);
typedef struct AG_BRIDGED_TYPE(id) AGGraphContextStorage * AGGraphContextRef AG_SWIFT_NAME(GraphContext);

struct AGGraphStorage;
struct AGGraphContextStorage;
struct AGSubgraphStorage;

typedef uint32_t AGAttribute AG_SWIFT_STRUCT AG_SWIFT_NAME(AnyAttribute);

AG_ASSUME_NONNULL_BEGIN

AG_IMPLICIT_BRIDGING_ENABLED

// MARK: - Exported C functions

AG_EXTERN_C_BEGIN

// Test
AG_EXPORT
AG_REFINED_FOR_SWIFT
AGGraphRef AGGraphCreate(void) AG_SWIFT_NAME(AGGraphRef.init());

AG_EXPORT
AG_REFINED_FOR_SWIFT
AGGraphRef AGGraphCreateShared(_Nullable AGGraphRef graph) AG_SWIFT_NAME(AGGraphRef.init(shared:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
CFTypeID AGGraphGetTypeID(void) AG_SWIFT_NAME(getter:AGGraphRef.typeID());

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGGraphStartProfiling(_Nullable AGGraphRef graph);

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGGraphStopProfiling(_Nullable AGGraphRef graph);

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGGraphResetProfile(_Nullable AGGraphRef graph);

AG_EXPORT
AG_REFINED_FOR_SWIFT
const void * _Nullable AGGraphGetContext(AGGraphRef graph) AG_SWIFT_NAME(getter:AGGraphRef.context(self:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGGraphSetContext(AGGraphRef graph, const void * _Nullable context) AG_SWIFT_NAME(setter:AGGraphRef.context(self:_:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
AGGraphContextRef AGGraphGetGraphContext(AGGraphRef graph) AG_SWIFT_NAME(getter:AGGraphRef.graphContext(self:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGGraphInvalidate(AGGraphRef graph) AG_SWIFT_NAME(AGGraphRef.invalidate(self:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGGraphInvalidateAllValues(AGGraphRef graph) AG_SWIFT_NAME(AGGraphRef.invalidateAllValues(self:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGGraphSetInvalidationCallback(AGGraphRef graph,
                                    const void (*_Nullable function)(const void * _Nullable context AG_SWIFT_CONTEXT, AGAttribute) AG_SWIFT_CC(swift),
                                    const void * _Nullable context);

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGGraphSetUpdateCallback(AGGraphRef graph,
                               const void (*_Nullable function)(const void * _Nullable context AG_SWIFT_CONTEXT) AG_SWIFT_CC(swift),
                               const void * _Nullable context);

AG_EXPORT
AG_REFINED_FOR_SWIFT
uint64_t AGGraphGetCounter(AGGraphRef graph, AGCounterQueryType query) AG_SWIFT_NAME(AGGraphRef.counter(self:for:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGGraphSetUpdate(const void * _Nullable value) AG_SWIFT_NAME(AGGraphRef.setUpdate(_:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
const void * _Nullable AGGraphClearUpdate(void) AG_SWIFT_NAME(AGGraphRef.clearUpdate());

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGGraphSetNeedsUpdate(AGGraphRef graph) AG_SWIFT_NAME(AGGraphRef.setNeedsUpdate(self:));

#if AG_TARGET_OS_DARWIN
AG_EXPORT
AG_REFINED_FOR_SWIFT
bool AGGraphAnyInputsChanged(const AGAttribute *inputs AG_COUNTED_BY(count), size_t count);
#else
// __counted_by__ is supported with Swift 6.1+ toolchain's clang on Linux.
// But it required the count to be declared first which is not required on Apple clang.
// See https://github.com/OpenSwiftUIProject/AttributeGraph/issues/130
AG_EXPORT
AG_REFINED_FOR_SWIFT
bool AGGraphAnyInputsChanged(const AGAttribute *inputs, size_t count);
#endif

AG_EXTERN_C_END

AG_IMPLICIT_BRIDGING_DISABLED

AG_ASSUME_NONNULL_END

#endif /* AGGraph_h */
