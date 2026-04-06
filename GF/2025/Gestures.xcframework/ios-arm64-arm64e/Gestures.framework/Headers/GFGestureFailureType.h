//
//  GFGestureFailureType.h
//  Gestures
//
//  Audited for 9126.1.5
//  Status: WIP

#ifndef GFGestureFailureType_h
#define GFGestureFailureType_h

#include <Gestures/GFBase.h>

typedef GF_ENUM(NSInteger, GFGestureFailureType) {
    GFGestureFailureTypeExcluded = 0,
    GFGestureFailureTypeFailureDependency = 1,
    GFGestureFailureTypeCustomError = 2,
    GFGestureFailureTypeDisabled = 3,
    GFGestureFailureTypeRemovedFromContainer = 4,
    GFGestureFailureTypeActivationDenied = 5,
    GFGestureFailureTypeAborted = 6,
    GFGestureFailureTypeCoordinatorChanged = 7,
};

#endif /* GFGestureFailureType_h */
