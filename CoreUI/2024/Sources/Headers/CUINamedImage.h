//
//  CUINamedImage.h
//  CoreUI
//
//  Audited for 918.3
//  Status: WIP

#import <CoreUI/CUIBase.h>
#import <CoreUI/CUINamedLookup.h>
#import <CoreUI/CUITypes.h>
#import <CoreGraphics/CoreGraphics.h>

CUI_ASSUME_NONNULL_BEGIN

@interface CUINamedImage : CUINamedLookup

@property (readonly, nonatomic, nullable) CGImageRef image;
@property (readonly, nonatomic) CUIImageType imageType;
@property (readonly, nonatomic) CGSize size;
@property (readonly, nonatomic) CGFloat scale;
@property (readonly, nonatomic, nullable) id baseKey;
@property (readonly, nonatomic) CGFloat opacity;
@property (readonly, nonatomic) int blendMode;
@property (readonly, nonatomic) int exifOrientation;

@property (readonly, nonatomic) BOOL isFlippable;
@property (readonly, nonatomic) BOOL isTemplate;
@property (readonly, nonatomic) CUIRenderMode templateRenderingMode;
@property (readonly, nonatomic) CUIResizingMode resizingMode;

@property (readonly, nonatomic) BOOL isVectorBased;
@property (readonly, nonatomic) BOOL isStructured;
@property (readonly, nonatomic) BOOL preservedVectorRepresentation;

@property (readonly, nonatomic) CGRect alphaCroppedRect;
@property (readonly, nonatomic) BOOL isAlphaCropped;
@property (readonly, nonatomic, nullable) CGImageRef croppedImage;
@property (readonly, nonatomic) CGSize originalUncroppedSize;

@property (readonly, nonatomic) BOOL hasSliceInformation;
@property (readonly, nonatomic) BOOL hasAlignmentInformation;

- (CUIResizingMode)resizingModeWithSubtype:(CUISubtype)subtype;
- (CGFloat)positionOfSliceBoundary:(unsigned int)boundary;
- (nullable CGImageRef)createImageFromPDFRenditionWithScale:(double)scale;

@end

CUI_ASSUME_NONNULL_END
