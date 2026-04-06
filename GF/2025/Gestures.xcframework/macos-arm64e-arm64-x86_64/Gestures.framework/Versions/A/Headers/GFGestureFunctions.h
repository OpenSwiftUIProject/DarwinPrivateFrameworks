//
//  GFGestureFunctions.h
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

#ifndef GFGestureFunctions_h
#define GFGestureFunctions_h

#include <Gestures/GFBase.h>
#include <Gestures/GFGestureFailureType.h>

#import <Foundation/Foundation.h>

@protocol GFGestureNode;
@protocol GFGestureNodeCoordinator;

GF_EXTERN_C_BEGIN

GF_ASSUME_NONNULL_BEGIN

/// Create a default gesture node with the given key.
GF_EXPORT id<GFGestureNode> _Nonnull GFGestureNodeCreateDefault(NSInteger key);

/// Get the default value for a gesture node.
GF_EXPORT id _Nonnull GFGestureNodeDefaultValue(void);

/// Create a gesture node coordinator with lifecycle callbacks.
GF_EXPORT id<GFGestureNodeCoordinator> _Nonnull GFGestureNodeCoordinatorCreate(
    void (^ _Nullable willUpdateHandler)(void),
    void (^ _Nullable didUpdateHandler)(void)
);

/// Bind a gesture component controller to a gesture node.
GF_EXPORT void GFGestureComponentControllerSetNode(
    id _Nonnull controller,
    id<GFGestureNode> _Nullable node
);

/// Check if a gesture failure type is terminated.
GF_EXPORT bool GFGestureFailureTypeIsTerminated(GFGestureFailureType type);

GF_ASSUME_NONNULL_END

GF_EXTERN_C_END

#endif /* GFGestureFunctions_h */
