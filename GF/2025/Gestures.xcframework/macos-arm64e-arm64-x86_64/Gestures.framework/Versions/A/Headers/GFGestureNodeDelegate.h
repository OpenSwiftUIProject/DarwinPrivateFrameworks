//
//  GFGestureNodeDelegate.h
//  Gestures

#ifndef GFGestureNodeDelegate_h
#define GFGestureNodeDelegate_h

#include <Gestures/GSBase.h>
#include <Gestures/GFGesturePhase.h>
#include <Gestures/GFGestureRelation.h>

#import <Foundation/Foundation.h>

@protocol GFGestureNode;

NS_ASSUME_NONNULL_BEGIN

@protocol GFGestureNodeDelegate <NSObject>

@optional
- (BOOL)gestureNodeShouldActivate:(id<GFGestureNode>)node;
- (void)gestureNodeWillUnblock:(id<GFGestureNode>)node;
- (void)gestureNode:(id<GFGestureNode>)node didEnqueuePhase:(GFGesturePhase)phase;
- (void)gestureNode:(id<GFGestureNode>)node didUpdatePhase:(GFGesturePhase)phase;
- (GFGestureRelationRole)gestureNode:(id<GFGestureNode>)node
                roleForRelationType:(GFGestureRelationType)type
                        relatedNode:(id<GFGestureNode>)relatedNode;

@end

NS_ASSUME_NONNULL_END

#endif /* GFGestureNodeDelegate_h */
