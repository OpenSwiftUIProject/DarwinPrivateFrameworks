//
//  GFGestureNode.h
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

#ifndef GFGestureNode_h
#define GFGestureNode_h

#include <Gestures/GFBase.h>
#include <Gestures/GFGesturePhase.h>
#include <Gestures/GFGestureRelation.h>

#import <Foundation/Foundation.h>

@protocol GFGestureNodeDelegate;
@protocol GFGestureNodeContainer;
@protocol GFGestureNodeCoordinator;

NS_ASSUME_NONNULL_BEGIN

@protocol GFGestureNode <NSObject>

@required

@property (nonatomic, weak, nullable) id<GFGestureNodeDelegate> delegate;
@property (nonatomic, weak, nullable) id<GFGestureNodeContainer> container;
@property (nonatomic, nullable) id<GFGestureNodeCoordinator> coordinator;
@property (nonatomic, readonly) NSInteger phase;
@property (nonatomic, getter=isBlocked, readonly) BOOL blocked;
@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, copy, nullable) NSString *tag;
@property (nonatomic, getter=isDisabled) BOOL disabled;
@property (nonatomic) BOOL disallowExclusionWithUnresolvedFailureRequirements;
@property (nonatomic, readonly) NSInteger platformKey;
@property (nonatomic, readonly, nullable) NSError *failureReason;

- (void)setDelegate:(nullable id<GFGestureNodeDelegate>)delegate;
- (void)setContainer:(nullable id<GFGestureNodeContainer>)container;
- (void)setCoordinator:(nullable id<GFGestureNodeCoordinator>)coordinator;
- (void)setTag:(nullable NSString *)tag;
- (BOOL)abort:(NSError * _Nullable *)error;
- (void)addRelationWithType:(NSInteger)type role:(NSInteger)role relatedNode:(id<GFGestureNode>)relatedNode;
- (BOOL)ensureUpdated:(NSError * _Nullable *)error;
- (BOOL)failWithReason:(nullable NSNumber *)reason error:(NSError * _Nullable *)error;
- (void)removeRelationWithType:(NSInteger)type role:(NSInteger)role relatedNode:(id<GFGestureNode>)relatedNode;
- (void)setDisabled:(BOOL)disabled;
- (void)setDisallowExclusionWithUnresolvedFailureRequirements:(BOOL)unresolvedFailureRequirements;
- (void)setTracking:(BOOL)tracking eventsWithIdentifiers:(NSArray *)identifiers;
- (BOOL)updateWithValue:(nullable id)value isFinal:(BOOL)isFinal error:(NSError * _Nullable *)error;

@end

NS_ASSUME_NONNULL_END

#endif /* GFGestureNode_h */
