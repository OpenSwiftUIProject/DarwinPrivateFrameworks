//
//  RBColor.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>
#include <RenderBox/RBColorSpace.h>
#include <CoreGraphics/CGColor.h>

RB_ASSUME_NONNULL_BEGIN

RB_EXTERN_C_BEGIN

typedef float RBColorComponent;

typedef struct RBColor {
    RBColorComponent red;
    RBColorComponent green;
    RBColorComponent blue;
    RBColorComponent alpha;
} RBColor;

RB_EXPORT const RBColor RBColorClear RB_SWIFT_NAME(RBColor.clear);
RB_EXPORT const RBColor RBColorBlack RB_SWIFT_NAME(RBColor.black);
RB_EXPORT const RBColor RBColorWhite RB_SWIFT_NAME(RBColor.white);
RB_EXPORT const RBColor RBColorNull RB_SWIFT_NAME(RBColor.null);
RB_EXPORT const RBColorComponent RBColorInvalidComponent RB_SWIFT_NAME(RBColor.invalidComponent);

RB_EXPORT RBColor RBColorMake(float red, float green, float blue, float alpha) RB_SWIFT_NAME(RBColor.init(red:green:blue:alpha:));
RB_EXPORT RBColor RBColorMakeLinear(float red, float green, float blue, float alpha) RB_SWIFT_NAME(RBColor.init(linearRed:green:blue:alpha:));
RB_EXPORT RBColor RBColorToLinear(RBColor color) RB_SWIFT_NAME(getter:RBColor.linear(self:));
RB_EXPORT RBColor RBColorFromLinear(RBColor color) RB_SWIFT_NAME(RBColor.fromLinear(self:));
RB_EXPORT bool RBColorEqualToColor(RBColor lhs, RBColor rhs) RB_SWIFT_NAME(RBColor.isEqual(self:to:));

RB_EXPORT RBColor RBColorFromComponents(CGColorSpaceRef colorSpace, const CGFloat *components, bool premultiplied) RB_SWIFT_NAME(RBColor.init(colorSpace:components:premultiplied:));
RB_EXPORT RBColor RBColorFromComponents2(CGColorSpaceRef colorSpace, const CGFloat *components, size_t componentCount) RB_SWIFT_NAME(RBColor.init(colorSpace:components:componentCount:));
RB_EXPORT RBColor RBColorFromCGColor(CGColorRef color, bool premultiplied) RB_SWIFT_NAME(RBColor.init(_:premultiplied:));
RB_EXPORT RBColor RBColorFromCGColor2(CGColorRef color, size_t componentCount) RB_SWIFT_NAME(RBColor.init(_:componentCount:));

RB_EXPORT CGColorRef _Nullable RBColorCopyCGColor(RBColor color, RBColorSpace rbColorSpace) CF_RETURNS_RETAINED RB_SWIFT_NAME(RBColor.cgColor(self:colorSpace:));

RB_EXTERN_C_END

RB_ASSUME_NONNULL_END

