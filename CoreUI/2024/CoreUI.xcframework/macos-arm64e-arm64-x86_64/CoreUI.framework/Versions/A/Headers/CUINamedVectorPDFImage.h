//
//  CUINamedVectorPDFImage.h
//  CoreUI
//
//  Audited for 918.3
//  Status: Complete

#import <CoreUI/CUINamedVectorImage.h>

CUI_ASSUME_NONNULL_BEGIN

@interface CUINamedVectorPDFImage : CUINamedVectorImage

@property (nonatomic, readonly, nullable) CGPDFDocumentRef pdfDocument;

- (nullable CGImageRef)rasterizeImageUsingScaleFactor:(CGFloat)scaleFactor forTargetSize:(CGSize)targetSize;

@end

CUI_ASSUME_NONNULL_END
