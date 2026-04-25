//
//  AGValueState.h
//  AttributeGraph

#ifndef AGValueState_h
#define AGValueState_h

#include <AttributeGraph/AGBase.h>

AG_ASSUME_NONNULL_BEGIN

typedef AG_OPTIONS(uint8_t, AGValueState) {
    AGValueStateNone = 0,
    AGValueStateDirty = 1 << 0,
    AGValueStatePending = 1 << 1,
    AGValueStateUpdating = 1 << 2,
    AGValueStateValueExists = 1 << 3,
    AGValueStateMainThread = 1 << 4,
    AGValueStateMainRef = 1 << 5,
    AGValueStateRequiresMainThread = 1 << 6,
    AGValueStateSelfModified = 1 << 7,
} AG_SWIFT_NAME(ValueState);

AG_ASSUME_NONNULL_END

#endif /* AGValueState_h */
