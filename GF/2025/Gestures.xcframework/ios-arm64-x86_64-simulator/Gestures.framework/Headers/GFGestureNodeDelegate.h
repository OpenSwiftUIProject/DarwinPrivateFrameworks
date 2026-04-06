//
//  GFGestureNodeDelegate.h
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

#ifndef GFGestureNodeDelegate_h
#define GFGestureNodeDelegate_h

#include <Gestures/GFBase.h>
#include <Gestures/GFGesturePhase.h>
#include <Gestures/GFGestureRelation.h>

#import <Foundation/Foundation.h>

@protocol GFGestureNode;

NS_ASSUME_NONNULL_BEGIN

@protocol GFGestureNodeDelegate <NSObject>

@required

- (void)gestureNode:(id<GFGestureNode>)gestureNode didUpdatePhase:(NSInteger)phase;
- (nullable id)gestureNode:(id<GFGestureNode>)gestureNode roleForRelationType:(NSInteger)relationType relatedNode:(id<GFGestureNode>)relatedNode;
- (BOOL)gestureNodeShouldActivate:(id<GFGestureNode>)node;
- (void)gestureNodeWillUnblock:(id<GFGestureNode>)node;

@optional

- (void)gestureNode:(id<GFGestureNode>)gestureNode didEnqueuePhase:(NSInteger)phase;
- (void)gestureNodeWillAbort:(id<GFGestureNode>)node;

@end

NS_ASSUME_NONNULL_END

#endif /* GFGestureNodeDelegate_h */
