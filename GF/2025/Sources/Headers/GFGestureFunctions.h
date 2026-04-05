//
//  GFGestureFunctions.h
//  Gestures

#ifndef GFGestureFunctions_h
#define GFGestureFunctions_h

#include <Gestures/GSBase.h>
#include <Gestures/GFGesturePhase.h>

#import <Foundation/Foundation.h>

@protocol GFGestureNode;
@protocol GFGestureNodeCoordinator;

GS_EXTERN_C_BEGIN

/// Create a default gesture node with the given key.
GS_EXPORT id<GFGestureNode> _Nonnull GFGestureNodeCreateDefault(NSInteger key);

/// Create a gesture node coordinator with lifecycle callbacks.
GS_EXPORT id<GFGestureNodeCoordinator> _Nonnull GFGestureNodeCoordinatorCreate(
    void (^ _Nullable willUpdateHandler)(void),
    void (^ _Nullable didUpdateHandler)(void)
);

/// Bind a gesture component controller to a gesture node.
GS_EXPORT void GFGestureComponentControllerSetNode(
    id _Nonnull controller,
    id<GFGestureNode> _Nullable node
);

/// Check if a gesture failure type is terminated.
GS_EXPORT bool GFGestureFailureTypeIsTerminated(GFGesturePhase phase);

/// Get the default value for a gesture node.
GS_EXPORT id _Nullable GFGestureNodeDefaultValue(void);

GS_EXTERN_C_END

#endif /* GFGestureFunctions_h */
