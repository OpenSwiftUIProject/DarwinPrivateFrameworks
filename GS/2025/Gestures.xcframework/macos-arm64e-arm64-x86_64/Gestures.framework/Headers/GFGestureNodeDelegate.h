//
//  GFGestureNodeDelegate.h
//  Gestures

#ifndef GFGestureNodeDelegate_h
#define GFGestureNodeDelegate_h

#include <Gestures/GSBase.h>
#include <Gestures/GFGesturePhase.h>
#include <Gestures/GFGestureRelation.h>

#if __OBJC__
#import <Foundation/Foundation.h>

@protocol GFGestureNode;

NS_ASSUME_NONNULL_BEGIN

@protocol GFGestureNodeDelegate <NSObject>

@optional
- (BOOL)gestureNodeShouldActivate:(id<GFGestureNode>)node;
- (void)gestureNodeWillUnblock:(id<GFGestureNode>)node;
- (void)gestureNode:(id<GFGestureNode>)node didEnqueuePhase:(struct GFGesturePhase)phase;
- (void)gestureNode:(id<GFGestureNode>)node didUpdatePhase:(struct GFGesturePhase)phase;
- (struct GFGestureRelationRole)gestureNode:(id<GFGestureNode>)node
                       roleForRelationType:(struct GFGestureRelationType)type
                               relatedNode:(id<GFGestureNode>)relatedNode;

@end

NS_ASSUME_NONNULL_END

#endif /* __OBJC__ */

#endif /* GFGestureNodeDelegate_h */
