//
//  RBSymbolUpdate.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>
#include <RenderBox/RBBlendMode.h>
#include <RenderBox/RBColor.h>
#include <RenderBox/RBDrawingState.h>
#include <RenderBox/RBPath.h>

#if RB_OBJC_FOUNDATION
#include <Foundation/Foundation.h>
#endif

RB_ASSUME_NONNULL_BEGIN

typedef RB_OPTIONS(uint32_t, RBSymbolUpdateFlags) {
    RBSymbolUpdateFlagsSwapAxes = 1 << 0,
    RBSymbolUpdateFlagsFlipX = 1 << 1,
    RBSymbolUpdateFlagsFlipY = 1 << 2,
    RBSymbolUpdateFlagsMergeLayers = 1 << 4,
    // Apply the glyph's vertical alignment offset to each layer transform.
    RBSymbolUpdateFlagsApplyVerticalOffset = 1 << 5,
};

typedef RB_OPTIONS(uint32_t, RBSymbolUpdateLayerFlags) {
    RBSymbolUpdateLayerFlagsIncludeClips = 1 << 0,
};

typedef RB_ENUM(uint32_t, RBSymbolStyle) {
    RBSymbolStylePrimary = 0,
    RBSymbolStyleSecondary = 5,
    RBSymbolStyleTertiary = 6,
    RBSymbolStyleQuaternary = 7,
    RBSymbolStyleQuinary = 8,
    RBSymbolStyleNamedColor = 9,
};

typedef struct _RBSymbolUpdate *RBSymbolUpdate RB_SWIFT_STRUCT;

// The update owns all layer data. A layer is valid until endUpdate:.
typedef struct RBSymbolUpdateLayer {
    RBSymbolUpdate update;
    intptr_t group;
    intptr_t index;
} RBSymbolUpdateLayer;

#if RB_OBJC_FOUNDATION

RB_EXTERN_C_BEGIN

RB_EXPORT double RBSymbolUpdateNextTime(RBSymbolUpdate update) RB_SWIFT_NAME(getter:RBSymbolUpdate.nextTime(self:));
RB_EXPORT uint32_t RBSymbolUpdateStyleMask(RBSymbolUpdate update) RB_SWIFT_NAME(getter:RBSymbolUpdate.styleMask(self:));
RB_EXPORT intptr_t RBSymbolUpdateGroupCount(RBSymbolUpdate update) RB_SWIFT_NAME(getter:RBSymbolUpdate.groupCount(self:));
RB_EXPORT intptr_t RBSymbolUpdateGroupSize(RBSymbolUpdate update, intptr_t group) RB_SWIFT_NAME(RBSymbolUpdate.groupSize(self:group:));
RB_EXPORT CGImageRef _Nullable RBSymbolUpdateTemplateImage(RBSymbolUpdate update, double * _Nullable scale, float * _Nullable opacity) CF_RETURNS_NOT_RETAINED RB_SWIFT_NAME(RBSymbolUpdate.templateImage(self:scale:opacity:));
RB_EXPORT void RBSymbolUpdateDrawWithStyleResolver(RBSymbolUpdate update, RBDrawingState state, RBColor (^resolver)(RBSymbolStyle, NSString * _Nullable)) RB_SWIFT_NAME(RBSymbolUpdate.draw(self:in:resolver:));

RB_EXPORT float RBSymbolUpdateLayerDrawingOpacity(RBSymbolUpdateLayer layer) RB_SWIFT_NAME(getter:RBSymbolUpdateLayer.drawingOpacity(self:));
RB_EXPORT RBSymbolStyle RBSymbolUpdateLayerStyle(RBSymbolUpdateLayer layer) RB_SWIFT_NAME(getter:RBSymbolUpdateLayer.style(self:));
RB_EXPORT NSString * _Nullable RBSymbolUpdateLayerColorName(RBSymbolUpdateLayer layer) RB_SWIFT_NAME(getter:RBSymbolUpdateLayer.colorName(self:));
RB_EXPORT CGColorRef _Nullable RBSymbolUpdateLayerDefaultColor(RBSymbolUpdateLayer layer) CF_RETURNS_NOT_RETAINED RB_SWIFT_NAME(getter:RBSymbolUpdateLayer.defaultColor(self:));
// The update owns the returned path. Copy it before the update ends.
RB_EXPORT RBPath RBSymbolUpdateLayerPath(RBSymbolUpdateLayer layer, CGAffineTransform *transform, RBSymbolUpdateLayerFlags flags) RB_SWIFT_NAME(RBSymbolUpdateLayer.path(self:transform:flags:));
RB_EXPORT void RBSymbolUpdateLayerDraw(RBSymbolUpdateLayer layer, RBDrawingState state, RBColor color, float opacity, RBBlendMode blendMode, RBSymbolUpdateLayerFlags flags) RB_SWIFT_NAME(RBSymbolUpdateLayer.draw(self:in:color:opacity:blendMode:flags:));

RB_EXTERN_C_END

#endif /* RB_OBJC_FOUNDATION */

RB_ASSUME_NONNULL_END
