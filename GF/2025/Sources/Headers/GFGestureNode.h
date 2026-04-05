//
//  GFGestureNode.h
//  Gestures

#ifndef GFGestureNode_h
#define GFGestureNode_h

#include <Gestures/GSBase.h>
#include <Gestures/GFGesturePhase.h>
#include <Gestures/GFGestureRelation.h>

#import <Foundation/Foundation.h>

@protocol GFGestureNodeDelegate;
@protocol GFGestureNodeContainer;
@protocol GFGestureNodeCoordinator;

NS_ASSUME_NONNULL_BEGIN

@protocol GFGestureNode <NSObject>

@property (nonatomic, readonly) struct GFGesturePhase phase;
@property (nonatomic, readonly) NSInteger identifier;
@property (nonatomic, copy, nullable) NSString *tag;
@property (nonatomic, readonly, getter=isBlocked) BOOL blocked;
@property (nonatomic, getter=isDisabled) BOOL disabled;
@property (nonatomic, readonly, nullable) NSString *platformKey;
@property (nonatomic, readonly, nullable) NSNumber *failureReason;

@property (nonatomic, weak, nullable) id<GFGestureNodeDelegate> delegate;
@property (nonatomic, weak, nullable) id<GFGestureNodeContainer> container;
@property (nonatomic, weak, nullable) id<GFGestureNodeCoordinator> coordinator;

- (BOOL)updateWithValue:(nullable id)value isFinal:(BOOL)isFinal error:(NSError **)error;
- (void)ensureUpdated:(NSString *)reason;
- (BOOL)abort:(NSError **)error;
- (BOOL)failWithReason:(nullable NSNumber *)reason error:(NSError **)error;

- (void)addRelationWithType:(struct GFGestureRelationType)type
                       role:(struct GFGestureRelationRole)role
                relatedNode:(id<GFGestureNode>)node;
- (void)removeRelationWithType:(struct GFGestureRelationType)type
                          role:(struct GFGestureRelationRole)role
                   relatedNode:(id<GFGestureNode>)node;

- (void)setTracking:(BOOL)tracking eventsWithIdentifiers:(NSArray *)identifiers;

@property (nonatomic) BOOL disallowExclusionWithUnresolvedFailureRequirements;

@end

NS_ASSUME_NONNULL_END

#endif /* GFGestureNode_h */
