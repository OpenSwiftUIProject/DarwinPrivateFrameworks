//
//  AGGraphCounterQueryType.h
//  AttributeGraph

#ifndef AGGraphCounterQueryType_h
#define AGGraphCounterQueryType_h

#include <AttributeGraph/AGBase.h>

typedef AG_ENUM(uint32_t, AGGraphCounterQueryType) {
    AGGraphCounterQueryTypeNodes,
    AGGraphCounterQueryTypeTransactions,
    AGGraphCounterQueryTypeUpdates,
    AGGraphCounterQueryTypeChanges,
    AGGraphCounterQueryTypeContextID,
    AGGraphCounterQueryTypeGraphID,
    AGGraphCounterQueryTypeContextThreadUpdating,
    AGGraphCounterQueryTypeThreadUpdating,
    AGGraphCounterQueryTypeContextNeedsUpdate,
    AGGraphCounterQueryTypeNeedsUpdate,
    AGGraphCounterQueryTypeMainThreadUpdates,
    AGGraphCounterQueryTypeCreatedNodes,
    AGGraphCounterQueryTypeSubgraphs,
    AGGraphCounterQueryTypeCreatedSubgraphs,
} AG_SWIFT_NAME(AGGraphRef.CounterQueryType);

#endif /* AGGraphCounterQueryType_h */
