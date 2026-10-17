//
//  AGGraphContext.h
//  AttributeGraph

#ifndef AGGraphContext_h
#define AGGraphContext_h

#include <AttributeGraph/AGBase.h>
#include <AttributeGraph/AGGraph.h>

// MARK: - Exported C functions

AG_ASSUME_NONNULL_BEGIN

AG_IMPLICIT_BRIDGING_ENABLED

AG_EXTERN_C_BEGIN

AG_EXPORT
AG_REFINED_FOR_SWIFT
AGGraphRef AGGraphContextGetGraph(AGGraphContextRef context) AG_SWIFT_NAME(getter:AGGraphContextRef.graph(self:));

AG_EXTERN_C_END

AG_IMPLICIT_BRIDGING_DISABLED

AG_ASSUME_NONNULL_END

#endif /* AGGraphContext_h */
