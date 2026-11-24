//
//  CUIRenderer.h
//  CoreUI
//
//  Audited for 918.3
//  Status: WIP

#ifndef CUIRenderer_h
#define CUIRenderer_h

#include <CoreUI/CUIBase.h>
#include <CoreGraphics/CoreGraphics.h>
#include <TargetConditionals.h>

#if TARGET_OS_OSX

CUI_EXTERN_C_BEGIN
CUI_ASSUME_NONNULL_BEGIN

typedef struct OpaqueCUIRendererRef *CUIRendererRef;

CUI_EXPORT const CFStringRef kCUIRendererThemeFileBundleIdentifierKey;
CUI_EXPORT const CFStringRef kCUIRendererThemeFileNameKey;
CUI_EXPORT const CFStringRef kCUIRendererDefaultBlendModeKey;

CUI_EXPORT const CFStringRef kCUIWidgetKey;
CUI_EXPORT const CFStringRef kCUIWidgetFrameGroupBox;
CUI_EXPORT const CFStringRef kCUIWidgetFrameGroupBoxForm;
CUI_EXPORT const CFStringRef kCUIWidgetTitleBarCloseBox;
CUI_EXPORT const CFStringRef kCUIWidgetDisclosureTriangle;
CUI_EXPORT const CFStringRef kCUIWidgetOverlayScrollBar;
CUI_EXPORT const CFStringRef kCUIForegroundTintColor;
CUI_EXPORT const CFStringRef kCUIBezelTintColor;
CUI_EXPORT const CFStringRef kCUIColorTemperatureAdjustment;
CUI_EXPORT const CFStringRef kCUIBezelBrightnessMultiplier;
CUI_EXPORT const CFStringRef kCUITextGlyphBrightnessMultiplier;
CUI_EXPORT const CFStringRef kCUIScaleKey;
CUI_EXPORT const CFStringRef kCUIIsFlippedKey;
CUI_EXPORT const CFStringRef kCUIMaskOnlyKey;
CUI_EXPORT const CFStringRef kCUIVariantKey;
CUI_EXPORT const CFStringRef kCUIVariantFill;
CUI_EXPORT const CFStringRef kCUIVariantStroke;
CUI_EXPORT const CFStringRef kCUIStateActive;
CUI_EXPORT const CFStringRef kCUIStateInactive;
CUI_EXPORT const CFStringRef kCUIStatePressed;
CUI_EXPORT const CFStringRef kCUIMeasureWidth;
CUI_EXPORT const CFStringRef kCUIMeasureHeight;
CUI_EXPORT const CFStringRef kCUIMeasureContentInsetTopRight;
CUI_EXPORT const CFStringRef kCUIMeasureContentInsetBottomLeft;
CUI_EXPORT const CFStringRef kCUIMeasureEdgeInsetTopRight;
CUI_EXPORT const CFStringRef kCUIMeasureEdgeInsetBottomLeft;
CUI_EXPORT const CFStringRef kCUIMeasureBaseline;
CUI_EXPORT const CFStringRef kCUIMeasureBlendMode;

CUI_EXPORT CUIRendererRef _Nullable CUICreateRenderer(CFDictionaryRef options);
CUI_EXPORT void CUIRendererCopyProperties(CUIRendererRef renderer,
                                          CFArrayRef propertyNames,
                                          CFDictionaryRef _Nullable * _Nonnull properties);
CUI_EXPORT CGColorRef _Nullable CUICopyCustomColorWithOptions(CUIRendererRef renderer,
                                                             CFStringRef name,
                                                             CFDictionaryRef options) CF_RETURNS_RETAINED;

CUI_EXPORT int32_t CUIDraw(CUIRendererRef _Nullable renderer,
                          CGRect bounds,
                          CGContextRef context,
                          CFDictionaryRef options,
                          CFDictionaryRef _Nullable * _Nullable result);
CUI_EXPORT int32_t CUICreateLayerContents(CUIRendererRef renderer,
                                         CFDictionaryRef options,
                                         CGImageRef _Nullable * _Nonnull image,
                                         CGRect *contentsCenter);
CUI_EXPORT int32_t CUICopyMeasurements(CUIRendererRef renderer,
                                      CGRect bounds,
                                      CGContextRef _Nullable context,
                                      CFDictionaryRef options,
                                      CFArrayRef keys,
                                      CFDictionaryRef _Nullable * _Nonnull measurements);
CUI_EXPORT uint32_t CUICurrentPlatform(void);
CUI_EXPORT uint32_t CUIMaxScaleForTargetPlatform(uint32_t platform);

CUI_ASSUME_NONNULL_END
CUI_EXTERN_C_END

#endif /* TARGET_OS_OSX */

#endif /* CUIRenderer_h */
