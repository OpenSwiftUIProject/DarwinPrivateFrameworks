//
//  CUINamedVectorSVGImage.h
//  CoreUI
//
//  Audited for 918.3
//  Status: Complete

#import <CoreUI/CUINamedVectorImage.h>
#import <CoreUI/CoreGraphics_SPI.h>

CUI_ASSUME_NONNULL_BEGIN

@interface CUINamedVectorSVGImage : CUINamedVectorImage

@property (nonatomic, readonly, nullable) CGSVGDocumentRef svgDocument;

- (nullable CGImageRef)rasterizeImageUsingScaleFactor:(CGFloat)scaleFactor forTargetSize:(CGSize)targetSize;

@end

CUI_ASSUME_NONNULL_END
