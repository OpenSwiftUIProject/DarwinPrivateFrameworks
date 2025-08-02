//
//  AGGraphTracing.h
//  AttributeGraph

#ifndef AGGraphTracing_hpp
#define AGGraphTracing_hpp

#include <AttributeGraph/AGBase.h>
#include <AttributeGraph/AGGraph.h>

typedef AG_OPTIONS(uint32_t, AGGraphTraceFlags) {
    AGGraphTraceFlags_0 = 0,
    AGGraphTraceFlags_1 = 1 << 0,
    AGGraphTraceFlags_2 = 1 << 1,
} AG_SWIFT_NAME(AGGraphRef.TraceFlags);

AG_ASSUME_NONNULL_BEGIN

AG_IMPLICIT_BRIDGING_ENABLED

AG_EXTERN_C_BEGIN

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGGraphStartTracing(_Nullable AGGraphRef graph, AGGraphTraceFlags options) AG_SWIFT_NAME(AGGraphRef.startTracing(_:options:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGGraphStartTracing2(_Nullable AGGraphRef graph, AGGraphTraceFlags options, _Nullable CFArrayRef array);

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGGraphStopTracing(_Nullable AGGraphRef graph) AG_SWIFT_NAME(AGGraphRef.stopTracing(_:));

AG_EXTERN_C_END

AG_IMPLICIT_BRIDGING_DISABLED

AG_ASSUME_NONNULL_END

#endif /* AGGraphTracing_hpp */
