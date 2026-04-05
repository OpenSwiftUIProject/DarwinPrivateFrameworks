//
//  GFGestureNodeContainer.h
//  Gestures

#ifndef GFGestureNodeContainer_h
#define GFGestureNodeContainer_h

#include <Gestures/GSBase.h>

#if __OBJC__
#import <Foundation/Foundation.h>

@protocol GFGestureNode;

NS_ASSUME_NONNULL_BEGIN

@protocol GFGestureNodeContainer <NSObject>

- (NSInteger)indexOfGestureNode:(id<GFGestureNode>)node;
- (BOOL)isDescendantOfContainer:(id<GFGestureNodeContainer>)container
                  referenceNode:(id<GFGestureNode>)node;
- (BOOL)isDeeperThanContainer:(id<GFGestureNodeContainer>)container
                referenceNode:(id<GFGestureNode>)node;

@end

NS_ASSUME_NONNULL_END

#endif /* __OBJC__ */

#endif /* GFGestureNodeContainer_h */
