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

typedef struct CUIRenderer *CUIRendererRef;

CUI_EXPORT const CFStringRef kCUIRendererThemeFileBundleIdentifierKey;
CUI_EXPORT const CFStringRef kCUIRendererThemeFileNameKey;

CUI_EXPORT CUIRendererRef _Nullable CUICreateRenderer(CFDictionaryRef options);
CUI_EXPORT void CUIRendererCopyProperties(CUIRendererRef renderer,
                                          CFArrayRef propertyNames,
                                          CFDictionaryRef _Nullable * _Nonnull properties);
CUI_EXPORT CGColorRef _Nullable CUICopyCustomColorWithOptions(CUIRendererRef renderer,
                                                             CFStringRef name,
                                                             CFDictionaryRef options) CF_RETURNS_RETAINED;

CUI_ASSUME_NONNULL_END
CUI_EXTERN_C_END

#endif /* TARGET_OS_OSX */

#endif /* CUIRenderer_h */
