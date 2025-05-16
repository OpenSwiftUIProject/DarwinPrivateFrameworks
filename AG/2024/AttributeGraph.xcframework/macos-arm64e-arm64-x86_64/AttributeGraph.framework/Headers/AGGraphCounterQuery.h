//
//  AGCounterQueryType.h
//
//
//  Created by Kyle on 2024/3/8.
//

#ifndef AGGraphCounterQuery_h
#define AGGraphCounterQuery_h

#include "AGBase.h"

typedef AG_ENUM(uint32_t, AGGraphCounterQuery){
    AGGraphCounterQueryNodeCount,
    AGGraphCounterQueryTransactionCount,
    AGGraphCounterQueryUpdateCount,
    AGGraphCounterQueryChangeCount,
    AGGraphCounterQueryContextID,
    AGGraphCounterQueryGraphID,
    AGGraphCounterQueryContextThreadUpdating,
    AGGraphCounterQueryThreadUpdating,
    AGGraphCounterQueryContextNeedsUpdate,
    AGGraphCounterQueryNeedsUpdate,
    AGGraphCounterQueryMainThreadUpdateCount,
    AGGraphCounterQueryNodeTotalCount,
    AGGraphCounterQuerySubgraphCount,
    AGGraphCounterQuerySubgraphTotalCount,
};

#endif /* AGGraphCounterQuery_h */
