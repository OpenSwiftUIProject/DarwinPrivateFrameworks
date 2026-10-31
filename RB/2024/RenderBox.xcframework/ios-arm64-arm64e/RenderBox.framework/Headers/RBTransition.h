//
//  RBTransition.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>

RB_ASSUME_NONNULL_BEGIN

RB_EXTERN_C_BEGIN

typedef RB_ENUM(uint32_t, RBTransitionMethod) {
    RBTransitionMethodEmpty = 0,
    RBTransitionMethodDiff = 1,
    RBTransitionMethodForwards = 2,
    RBTransitionMethodBackwards = 3,
    RBTransitionMethodPrefix = 4,
    RBTransitionMethodSuffix = 5,
    RBTransitionMethodBinary = 6,
    RBTransitionMethodNone = 7,
    RBTransitionMethodPrefixAndSuffix = 8,
};

typedef RB_OPTIONS(uint32_t, RBTransitionEvents) {
    RBTransitionEventsAdd = 1 << 0,
    RBTransitionEventsRemove = 1 << 1,
    RBTransitionEventsAddRemove = RBTransitionEventsAdd | RBTransitionEventsRemove,
};

typedef RB_OPTIONS(uint32_t, RBTransitionEffectFlags) {
    RBTransitionEffectFlagsRemoveInverts = 1 << 0,
};

typedef RB_ENUM(uint32_t, RBTransitionEffectType) {
    RBTransitionEffectTypeNone = 0,
    RBTransitionEffectTypeAlpha = 1,
    RBTransitionEffectTypeScaleCenter = 2,
    RBTransitionEffectTypeTranslation = 3,
    RBTransitionEffectTypeBlur = 4,
    RBTransitionEffectTypeMatchMove = 5,
    RBTransitionEffectTypeScaleOrigin = 6,
    RBTransitionEffectTypeAnchorLeft = 7,
    RBTransitionEffectTypeAnchorRight = 8,
    RBTransitionEffectTypeAnchorUp = 9,
    RBTransitionEffectTypeAnchorDown = 10,
    RBTransitionEffectTypeSequenceLeft = 11,
    RBTransitionEffectTypeSequenceRight = 12,
    RBTransitionEffectTypeSequenceUp = 13,
    RBTransitionEffectTypeSequenceDown = 14,
    RBTransitionEffectTypeRelativeTranslation = 15,
    RBTransitionEffectTypeRelativeBlur = 16,
    RBTransitionEffectTypeAppearDisappear = 17,
    RBTransitionEffectTypeReplace = 18,
    RBTransitionEffectTypeSequenceForwards = 19,
    RBTransitionEffectTypeSequenceBackwards = 20,
};

RB_EXTERN_C_END

RB_ASSUME_NONNULL_END

#if RB_OBJC_FOUNDATION

#include <Foundation/Foundation.h>
#include <RenderBox/RBAnimation.h>

RB_ASSUME_NONNULL_BEGIN

@interface RBTransitionEffect : NSObject

@property (nonatomic) RBTransitionEffectType type;
@property (nonatomic) RBTransitionEffectFlags flags;
@property (nonatomic) RBTransitionEvents events;
@property (nonatomic) float beginTime;
@property (nonatomic) float duration;
@property (nonatomic) NSUInteger animationIndex;
@property (nonatomic) NSUInteger insertAnimationIndex;
@property (nonatomic) NSUInteger removeAnimationIndex;

- (float)argumentValueAtIndex:(NSUInteger)index;
- (void)setArgumentValue:(float)value atIndex:(NSUInteger)index;
- (uint32_t)integerArgumentValueAtIndex:(NSUInteger)index;
- (void)setIntegerArgumentValue:(uint32_t)value atIndex:(NSUInteger)index;

@end

@interface RBTransition : NSObject <NSCopying>

@property (class, readonly, nonatomic) RBTransition *defaultTransition;
@property (nonatomic) RBTransitionMethod method;
@property (nonatomic, strong, nullable) RBAnimation *animation;
@property (nonatomic) uint32_t maxChanges;
@property (nonatomic, getter=isReplaceable) BOOL replaceable;
@property (readonly, nonatomic, copy) NSArray<RBTransitionEffect *> *effects;
@property (nonatomic) float addRemoveDuration;

- (void)addEffect:(nullable RBTransitionEffect *)effect;

@end

RB_ASSUME_NONNULL_END

#endif /* RB_OBJC_FOUNDATION */
