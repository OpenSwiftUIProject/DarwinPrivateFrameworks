//
//  CUINamedVectorImage.h
//  CoreUI
//
//  Audited for 918.3
//  Status: WIP

#import <CoreUI/CUIBase.h>
#import <CoreUI/CUINamedLookup.h>
#import <CoreGraphics/CoreGraphics.h>

CUI_ASSUME_NONNULL_BEGIN

@interface CUINamedVectorImage : CUINamedLookup

@property (nonatomic, readonly) CGFloat scale;
@property (nonatomic, readonly, nullable) CGPDFDocumentRef pdfDocument;

- (nullable CGImageRef)rasterizeImageUsingScaleFactor:(CGFloat)scaleFactor forTargetSize:(CGSize)targetSize;

@end

CUI_ASSUME_NONNULL_END
