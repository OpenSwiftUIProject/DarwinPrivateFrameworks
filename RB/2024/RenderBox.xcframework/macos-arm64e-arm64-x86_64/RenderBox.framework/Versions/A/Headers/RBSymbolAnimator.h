//
//  RBSymbolAnimator.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>
#include <RenderBox/RBColor.h>
#include <RenderBox/RBSymbolAnimation.h>

#if RB_OBJC_FOUNDATION

#include <RenderBox/RBSymbolAnimatorObserver.h>
#include <Foundation/Foundation.h>
#include <CoreGraphics/CoreGraphics.h>

RB_ASSUME_NONNULL_BEGIN

@class CUINamedVectorGlyph;
struct _RBSymbolUpdate;

@interface RBSymbolAnimator : NSObject

@property (retain, nonatomic, nullable) CUINamedVectorGlyph *glyph;
@property (nonatomic) unsigned int renderingMode;
@property (nonatomic) BOOL flipsRightToLeft;
@property (nonatomic) double variableValue;
@property (nonatomic) RBColor opacities;
@property (nonatomic, getter=isHidden) BOOL hidden;
@property (nonatomic) RBSymbolScaleLevel scaleLevel;
@property (nonatomic) CGPoint anchorPoint;
@property (nonatomic) CGPoint position;
@property (nonatomic) CGSize size;
@property (nonatomic) CGPoint presentationPosition;
@property (nonatomic) double currentTime;
@property (readonly, nonatomic) double maxVelocity;
@property (readonly, nonatomic) unsigned int version;
@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (readonly, nonatomic) CGRect alignmentRect;
@property (readonly, nonatomic) CGRect unroundedAlignmentRect;
@property (readonly, nonatomic) unsigned int styleMask;
@property (nonatomic) unsigned int depth;
@property (readonly, nonatomic) CGRect boundingRect;

/* instance methods */
- (unsigned int)addAnimation:(RBSymbolAnimation)animation options:(nullable id)options RB_SWIFT_NAME(addAnimation(_:options:));
- (struct _RBSymbolUpdate *)beginUpdateWithRenderingMode:(unsigned int)mode;
- (void)endUpdate:(struct _RBSymbolUpdate *)update;
- (void)removeAllAnimations;
- (void)removeAnimation:(RBSymbolAnimation)animation RB_SWIFT_NAME(removeAnimation(_:));
- (struct _RBSymbolUpdate *)beginUpdateWithRenderingMode:(unsigned int)mode position:(nullable const CGPoint *)position size:(nullable const CGSize *)size flags:(unsigned int)flags;
- (void)cancelAllAnimations;
- (void)cancelAnimation:(RBSymbolAnimation)animation RB_SWIFT_NAME(cancelAnimation(_:));
- (void)cancelAnimationWithID:(unsigned int)animationID;
- (RBColor)colorForStyle:(unsigned int)style;
- (nullable id)copyDebugDescriptionForUpdate:(struct _RBSymbolUpdate *)update;
- (void)removeAnimationWithID:(unsigned int)animationID;
- (void)setColor:(RBColor)color forStyle:(unsigned int)style;
- (void)setPriority:(float)priority ofAnimationWithID:(unsigned int)animationID;
- (void)addObserver:(id<RBSymbolAnimatorObserver>)observer;
- (void)removeObserver:(id<RBSymbolAnimatorObserver>)observer;

@end

RB_ASSUME_NONNULL_END

#endif /* RB_OBJC_FOUNDATION */
