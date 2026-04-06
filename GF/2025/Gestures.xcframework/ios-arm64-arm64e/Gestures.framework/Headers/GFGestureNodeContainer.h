//
//  GFGestureNodeContainer.h
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

#ifndef GFGestureNodeContainer_h
#define GFGestureNodeContainer_h

#include <Gestures/GFBase.h>

#import <Foundation/Foundation.h>

@protocol GFGestureNode;

NS_ASSUME_NONNULL_BEGIN

@protocol GFGestureNodeContainer <NSObject>

@required

- (NSInteger)indexOfGestureNode:(id<GFGestureNode>)node;
- (BOOL)isDeeperThanContainer:(id<GFGestureNodeContainer>)container referenceNode:(id<GFGestureNode>)referenceNode;
- (BOOL)isDescendantOfContainer:(id<GFGestureNodeContainer>)container referenceNode:(id<GFGestureNode>)referenceNode;

@end

NS_ASSUME_NONNULL_END

#endif /* GFGestureNodeContainer_h */
