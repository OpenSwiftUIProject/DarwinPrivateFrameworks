//
//  CUINamedVectorSVGImage.h
//  CoreUI
//
//  Audited for 918.3
//  Status: Complete

#import <CoreUI/CUINamedVectorImage.h>

typedef struct CF_BRIDGED_TYPE(id) CGSVGDocument *CGSVGDocumentRef;

CUI_ASSUME_NONNULL_BEGIN

@interface CUINamedVectorSVGImage : CUINamedVectorImage

@property (nonatomic, readonly, nullable) CGSVGDocumentRef svgDocument;

- (nullable CGImageRef)rasterizeImageUsingScaleFactor:(CGFloat)scaleFactor forTargetSize:(CGSize)targetSize;

@end

CUI_ASSUME_NONNULL_END
