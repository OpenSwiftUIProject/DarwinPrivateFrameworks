//
//  RBSymbolAnimation.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>

RB_EXTERN_C_BEGIN

typedef RB_ENUM(uint32_t, RBSymbolAnimation) {
    RBSymbolAnimationVariableValue = 0,
    RBSymbolAnimationVariableColor = 1,
    RBSymbolAnimationPulse = 2,
    RBSymbolAnimationBounce = 3,
    RBSymbolAnimationScale = 4,
    RBSymbolAnimationAppear = 5,
    RBSymbolAnimationReplace = 6,
    RBSymbolAnimationInterpolate = 7,
    RBSymbolAnimationPush = 8,
    RBSymbolAnimationDisappear = 9,
    RBSymbolAnimationWiggle = 10,
    RBSymbolAnimationRotate = 11,
    RBSymbolAnimationBreathe = 12,
};

typedef RB_ENUM(int32_t, RBSymbolScaleLevel) {
    RBSymbolScaleLevelDown = -1,
    RBSymbolScaleLevelNormal = 0,
    RBSymbolScaleLevelUp = 1,
};

typedef RB_OPTIONS(uint32_t, RBSymbolAnimationBreatheFlags) {
    RBSymbolAnimationBreatheFlagsOnlyScale = 1 << 0,
} RB_SWIFT_NAME(RBSymbolAnimation.BreatheOptions);

typedef RB_OPTIONS(uint32_t, RBSymbolAnimationBounceFlags) {
    RBSymbolAnimationBounceFlagsUp = 1 << 0,
    RBSymbolAnimationBounceFlagsDown = 1 << 1,
    RBSymbolAnimationBounceFlagsContinuous = 1 << 4,
} RB_SWIFT_NAME(RBSymbolAnimation.BounceOptions);

typedef RB_OPTIONS(uint32_t, RBSymbolAnimationWiggleFlags) {
    RBSymbolAnimationWiggleFlagsLocalized = 0x1,
    RBSymbolAnimationWiggleFlagsRotational = 0x3,
    RBSymbolAnimationWiggleFlagsForward = 0x10,
    RBSymbolAnimationWiggleFlagsBackward = 0x20,
    RBSymbolAnimationWiggleFlagsDirectionMask = 0xF0,
    RBSymbolAnimationWiggleFlagsContinuous = 0x100,
} RB_SWIFT_NAME(RBSymbolAnimation.WiggleOptions);

typedef RB_OPTIONS(uint32_t, RBSymbolAnimationRotateFlags) {
    RBSymbolAnimationRotateFlagsClockwise = 1 << 0,
    RBSymbolAnimationRotateFlagsCounterClockwise = 1 << 1,
    RBSymbolAnimationRotateFlagsContinuous = 1 << 4,
} RB_SWIFT_NAME(RBSymbolAnimation.RotateOptions);

typedef RB_OPTIONS(uint32_t, RBSymbolAnimationVariableColorFlags) {
    RBSymbolAnimationVariableColorFlagsIterative = 1 << 0,
    RBSymbolAnimationVariableColorFlagsHideInactiveLayers = 1 << 1,
    RBSymbolAnimationVariableColorFlagsReversing = 1 << 3,
} RB_SWIFT_NAME(RBSymbolAnimation.VariableColorOptions);

typedef RB_OPTIONS(uint32_t, RBSymbolAnimationAppearDisappearFlags) {
    RBSymbolAnimationAppearDisappearFlagsDown = 0x2,
    RBSymbolAnimationAppearDisappearFlagsUp = 0x3,
    RBSymbolAnimationAppearDisappearFlagsWholeSymbol = 0x10,
} RB_SWIFT_NAME(RBSymbolAnimation.AppearDisappearOptions);

typedef RB_OPTIONS(uint32_t, RBSymbolAnimationReplaceFlags) {
    RBSymbolAnimationReplaceFlagsDown = 0x2,
    RBSymbolAnimationReplaceFlagsUp = 0x3,
    RBSymbolAnimationReplaceFlagsOffUp = 0x4,
    RBSymbolAnimationReplaceFlagsWholeSymbol = 0x10,
    RBSymbolAnimationReplaceFlagsNoSlashes = 0x20,
    RBSymbolAnimationReplaceFlagsNoBadges = 0x40,
} RB_SWIFT_NAME(RBSymbolAnimation.ReplaceOptions);

RB_EXTERN_C_END

#if RB_OBJC_FOUNDATION

#include <Foundation/Foundation.h>

RB_ASSUME_NONNULL_BEGIN

typedef NSString *RBSymbolAnimationOptionKey NS_TYPED_EXTENSIBLE_ENUM RB_SWIFT_NAME(RBSymbolAnimation.OptionKey);

RB_EXPORT RBSymbolAnimationOptionKey const RBSymbolAnimationTiming;
RB_EXPORT RBSymbolAnimationOptionKey const RBSymbolAnimationSpeed;
RB_EXPORT RBSymbolAnimationOptionKey const RBSymbolAnimationClampsSpeed;
RB_EXPORT RBSymbolAnimationOptionKey const RBSymbolAnimationRepeatCount;
RB_EXPORT RBSymbolAnimationOptionKey const RBSymbolAnimationRepeatDelay;
RB_EXPORT RBSymbolAnimationOptionKey const RBSymbolAnimationPriority;
RB_EXPORT RBSymbolAnimationOptionKey const RBSymbolAnimationByLayer;
RB_EXPORT RBSymbolAnimationOptionKey const RBSymbolAnimationOnCompletion;
RB_EXPORT RBSymbolAnimationOptionKey const RBSymbolAnimationSymbolDefaults;
RB_EXPORT RBSymbolAnimationOptionKey const RBSymbolAnimationBreatheOptions;
RB_EXPORT RBSymbolAnimationOptionKey const RBSymbolAnimationPulseOptions;
RB_EXPORT RBSymbolAnimationOptionKey const RBSymbolAnimationBounceOptions;
RB_EXPORT RBSymbolAnimationOptionKey const RBSymbolAnimationWiggleOptions;
RB_EXPORT RBSymbolAnimationOptionKey const RBSymbolAnimationWiggleAngle;
RB_EXPORT RBSymbolAnimationOptionKey const RBSymbolAnimationRotateOptions;
RB_EXPORT RBSymbolAnimationOptionKey const RBSymbolAnimationVariableColorOptions;
RB_EXPORT RBSymbolAnimationOptionKey const RBSymbolAnimationAppearDisappearOptions;
RB_EXPORT RBSymbolAnimationOptionKey const RBSymbolAnimationReplaceOptions;
RB_EXPORT RBSymbolAnimationOptionKey const RBSymbolAnimationInterpolateOptions;

RB_ASSUME_NONNULL_END

#endif /* RB_OBJC_FOUNDATION */
