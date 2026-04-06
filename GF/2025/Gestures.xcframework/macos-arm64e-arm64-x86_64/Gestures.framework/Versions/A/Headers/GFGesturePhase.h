//
//  GFGesturePhase.h
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

#ifndef GFGesturePhase_h
#define GFGesturePhase_h

#include <Gestures/GFBase.h>

typedef GF_ENUM(NSInteger, GFGesturePhase) {
    GFGesturePhaseIdle = 0,
    GFGesturePhasePossible = 1,
    GFGesturePhaseBegan = 2,
    GFGesturePhaseChanged = 3,
    GFGesturePhaseEnded = 4,
    GFGesturePhaseCancelled = 5,
    GFGesturePhaseFailed = 6,
};

#endif /* GFGesturePhase_h */
