//
//  GFGesturePhase.h
//  Gestures

#ifndef GFGesturePhase_h
#define GFGesturePhase_h

#include <Gestures/GSBase.h>

GS_EXTERN_C_BEGIN

/// Gesture phase value bridged from Swift GesturePhase enum.
typedef struct GFGesturePhase {
    NSInteger rawValue;
} GFGesturePhase;

GS_EXTERN_C_END

#endif /* GFGesturePhase_h */
