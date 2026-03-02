//
//  RBAnimation.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>
#include <Foundation/Foundation.h>
#include <CoreGraphics/CoreGraphics.h>

RB_ASSUME_NONNULL_BEGIN

@interface RBAnimation : NSObject <NSCopying>

@property (readonly, nonatomic) double activeDuration;

/* instance methods */
- (id)copyWithZone:(nullable NSZone *)zone;
- (BOOL)isEqual:(nullable id)object;
- (void)removeAll;
- (float)evaluateAtTime:(double)time;
- (void)addBezierDuration:(double)duration controlPoint1:(CGPoint)point1 controlPoint2:(CGPoint)point2;
- (void)addDelay:(double)delay;
- (void)addPreset:(unsigned int)preset duration:(double)duration;
- (void)addRepeatCount:(double)count autoreverses:(BOOL)autoreverses;
- (void)addSampledFunctionWithDuration:(double)duration count:(unsigned long long)count values:(const float *)values;
- (void)addSpeed:(double)speed;
- (void)addSpringDuration:(double)duration mass:(double)mass stiffness:(double)stiffness damping:(double)damping initialVelocity:(double)velocity;

@end

RB_ASSUME_NONNULL_END
