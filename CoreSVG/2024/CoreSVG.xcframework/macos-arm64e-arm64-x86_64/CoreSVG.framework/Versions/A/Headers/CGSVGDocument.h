//
//  CGSVGDocument.h
//  CoreSVG
//
//  Audited for 341
//  Status: Complete

#pragma once

#include <CoreFoundation/CoreFoundation.h>
#include <CoreGraphics/CoreGraphics.h>

CF_ASSUME_NONNULL_BEGIN

typedef struct CF_BRIDGED_TYPE(id) CGSVGDocument *CGSVGDocumentRef;

CF_EXPORT
CFTypeID CGSVGDocumentGetTypeID(void);

CF_EXPORT
CGSVGDocumentRef _Nullable CGSVGDocumentCreateFromData(CFDataRef data, CFDictionaryRef _Nullable options);

CF_EXPORT
CGSVGDocumentRef CGSVGDocumentRetain(CGSVGDocumentRef document);

CF_EXPORT
void CGSVGDocumentRelease(CGSVGDocumentRef document);

CF_EXPORT
CGSize CGSVGDocumentGetCanvasSize(CGSVGDocumentRef document);

CF_EXPORT
void CGContextDrawSVGDocument(CGContextRef context, CGSVGDocumentRef document);

CF_ASSUME_NONNULL_END