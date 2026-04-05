//
//  GFGestureNodeCoordinator.h
//  Gestures

#ifndef GFGestureNodeCoordinator_h
#define GFGestureNodeCoordinator_h

#include <Gestures/GSBase.h>

#import <Foundation/Foundation.h>

@protocol GFGestureNode;

NS_ASSUME_NONNULL_BEGIN

@protocol GFGestureNodeCoordinator <NSObject>

@property (nonatomic, readonly) NSArray<id<GFGestureNode>> *nodes;
@property (nonatomic, copy, nullable) void (^willUpdateHandler)(void);
@property (nonatomic, copy, nullable) void (^didUpdateHandler)(void);
@property (nonatomic, copy, nullable) void (^willProcessUpdateQueueHandler)(void);

- (void)enqueueUpdatesForNodes:(NSArray<id<GFGestureNode>> *)nodes
                       inBlock:(void (^)(NSArray<id<GFGestureNode>> *))block
                        reason:(NSString *)reason;
- (void)processUpdatesWithReason:(NSString *)reason;
- (void)updateWithNodes:(NSArray<id<GFGestureNode>> *)nodes
                 reason:(NSString *)reason
          updateHandler:(void (^)(NSArray<id<GFGestureNode>> *))handler;
- (NSArray<id<GFGestureNode>> *)failureDependentsForNode:(id<GFGestureNode>)node;
- (BOOL)hasUnresolvedFailureDependenciesForNode:(id<GFGestureNode>)node;

@end

NS_ASSUME_NONNULL_END

#endif /* GFGestureNodeCoordinator_h */
