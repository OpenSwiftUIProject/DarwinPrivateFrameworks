//
//  AGGraphTracing.h
//  AttributeGraph

#ifndef AGGraphTracing_hpp
#define AGGraphTracing_hpp

#include <AttributeGraph/AGBase.h>
#include <AttributeGraph/AGGraph.h>
#include <AttributeGraph/AGUniqueID.h>

typedef AG_OPTIONS(uint32_t, AGGraphTraceFlags) {
    AGGraphTraceFlagsEnabled = 1 << 0,
    AGGraphTraceFlagsFull = 1 << 1,
    AGGraphTraceFlagsBacktrace = 1 << 2,
    AGGraphTraceFlagsPrepare = 1 << 3,
    AGGraphTraceFlagsCustom = 1 << 4,
    AGGraphTraceFlagsAll = 1 << 5,
} AG_SWIFT_NAME(AGGraphRef.TraceFlags);

typedef struct AGTrace *AGTraceRef;

AG_ASSUME_NONNULL_BEGIN

AG_IMPLICIT_BRIDGING_ENABLED

AG_EXTERN_C_BEGIN

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGGraphStartTracing(_Nullable AGGraphRef graph, AGGraphTraceFlags flags) AG_SWIFT_NAME(AGGraphRef.startTracing(_:flags:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGGraphStartTracing2(_Nullable AGGraphRef graph, AGGraphTraceFlags flags, _Nullable CFArrayRef subsystems) AG_SWIFT_NAME(AGGraphRef.startTracing(_:flags:subsystems:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGGraphStopTracing(_Nullable AGGraphRef graph) AG_SWIFT_NAME(AGGraphRef.stopTracing(_:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
AGUniqueID AGGraphAddTrace(AGGraphRef graph, const AGTraceRef trace, void *_Nullable context)
AG_SWIFT_NAME(AGGraphRef.addTrace(self:_:context:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGGraphRemoveTrace(AGGraphRef graph, AGUniqueID trace_id) AG_SWIFT_NAME(AGGraphRef.removeTrace(self:traceID:));

AG_EXTERN_C_END

AG_IMPLICIT_BRIDGING_DISABLED

AG_ASSUME_NONNULL_END

#endif /* AGGraphTracing_hpp */
