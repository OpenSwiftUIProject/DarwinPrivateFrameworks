//
//  GFGestureNodeCoordinator.h
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

#ifndef GFGestureNodeCoordinator_h
#define GFGestureNodeCoordinator_h

#include <Gestures/GFBase.h>

#import <Foundation/Foundation.h>

@protocol GFGestureNode;

NS_ASSUME_NONNULL_BEGIN

@protocol GFGestureNodeCoordinator <NSObject>

@required

@property (nonatomic, readonly) NSArray<id<GFGestureNode>> *nodes;
@property (nonatomic, copy, nullable) void (^willUpdateHandler)(void);
@property (nonatomic, copy, nullable) void (^willProcessUpdateQueueHandler)(void);
@property (nonatomic, copy, nullable) void (^didUpdateHandler)(void);

- (void)enqueueUpdatesForNodes:(NSArray<id<GFGestureNode>> *)nodes
                       inBlock:(void (^)(NSArray<id<GFGestureNode>> *))block
                        reason:(NSString *)reason;
- (BOOL)hasUnresolvedFailureDependenciesForNode:(id<GFGestureNode>)node;
- (void)setWillProcessUpdateQueueHandler:(nullable void (^)(void))handler;
- (void)updateWithNodes:(NSArray<id<GFGestureNode>> *)nodes
                 reason:(NSString *)reason
          updateHandler:(void (^)(NSArray<id<GFGestureNode>> *))handler;
- (NSArray<id<GFGestureNode>> *)failureDependentsForNode:(id<GFGestureNode>)node;
- (void)processUpdatesWithReason:(NSString *)reason;
- (void)setDidUpdateHandler:(nullable void (^)(void))handler;
- (void)setWillUpdateHandler:(nullable void (^)(void))handler;

@end

NS_ASSUME_NONNULL_END

#endif /* GFGestureNodeCoordinator_h */
