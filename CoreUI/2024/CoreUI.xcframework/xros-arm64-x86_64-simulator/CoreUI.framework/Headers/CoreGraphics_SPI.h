//
//  CoreGraphics_SPI.h
//  CoreUI
//
//  Audited for 918.3
//  Status: Complete

#pragma once

#include <CoreUI/CUIBase.h>

#if __has_include(<CoreGraphics/CoreGraphics.h>)
#include <CoreGraphics/CoreGraphics.h>

CUI_ASSUME_NONNULL_BEGIN

typedef struct CF_BRIDGED_TYPE(id) CGSVGDocument *CGSVGDocumentRef;

CUI_EXPORT
CFTypeID CGSVGDocumentGetTypeID(void);

CUI_EXPORT
CGSVGDocumentRef _Nullable CGSVGDocumentCreateFromData(CFDataRef data, CFDictionaryRef _Nullable options);

CUI_EXPORT
CGSVGDocumentRef CGSVGDocumentRetain(CGSVGDocumentRef document);

CUI_EXPORT
void CGSVGDocumentRelease(CGSVGDocumentRef document);

CUI_EXPORT
CGSize CGSVGDocumentGetCanvasSize(CGSVGDocumentRef document);

CUI_EXPORT
void CGContextDrawSVGDocument(CGContextRef context, CGSVGDocumentRef document);

CUI_ASSUME_NONNULL_END

#endif /* CoreGraphics.h */
