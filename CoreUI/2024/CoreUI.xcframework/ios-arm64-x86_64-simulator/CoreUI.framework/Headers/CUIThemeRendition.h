//
//  CUIThemeRendition.h
//  CoreUI
//
//  Audited for macOS 15.0
//  Status: WIP

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreUI/CUIBase.h>

CUI_ASSUME_NONNULL_BEGIN

typedef CUI_ENUM(FourCharCode, CUIPixelFormat) {
    CUIPixelFormatPDF  = 'PDF ',
    CUIPixelFormatHEIF = 'HEIF',
    CUIPixelFormatJPEG = 'JPEG',
};

typedef CUI_ENUM(NSInteger, CUIRenditionType) {
    CUIRenditionTypeGradient = 6,
};

@interface CUIThemeRendition : NSObject

@property (nonatomic) NSInteger type;
@property (nonatomic) uint32_t subtype;
@property (nonatomic) uint32_t internalScale;
@property (nonatomic) NSInteger internalTemplateRenderingMode;
@property (strong, nonatomic) NSString *internalName;
@property (readonly, nonatomic) NSData *srcData;
@property (nonatomic) double opacity;
@property (nonatomic) int blendMode;
@property (nonatomic) int exifOrientation;

+ (id)displayNameForRenditionType:(CUIRenditionType)renditionType;
+ (Class)renditionClassForRenditionType:(CUIRenditionType)renditionType andPixelFormat:(CUIPixelFormat)pixelFormat;

- (id)name;
- (id)data;
- (void)setName:(id)name;
- (int)pixelFormat;
- (double)scale;
- (CGColorRef)cgColor;
- (id)systemColorName;
- (id)metrics;
- (id)gradient;
- (BOOL)isFlippable;
- (BOOL)isOpaque;
- (CGPDFDocumentRef)pdfDocument;
- (id)properties;
- (BOOL)substituteWithSystemColor;
- (id)utiType;
- (BOOL)isTiled;
- (id)layerReferences;
- (CGRect)alphaCroppedRect;
- (id)assetPackIdentifier;
- (int)bitmapEncoding;
- (NSUInteger)colorSpaceID;
- (id)contentNames;
- (CGImageRef)createImageFromPDFRenditionWithScale:(double)scale;
- (BOOL)edgesOnly;
- (id)effectPreset;
- (id)externalTags;
- (double)gradientDrawingAngle;
- (uint32_t)gradientStyle;
- (id)imageForSliceIndex:(NSInteger)sliceIndex;
- (BOOL)isInternalLink;
- (BOOL)isInterpolatable;
- (BOOL)isScaled;
- (BOOL)isTintable;
- (BOOL)isVectorBased;
- (id)linkingToRendition;
- (id)maskForSliceIndex:(NSInteger)sliceIndex;
- (id)mipLevels;
- (id)modelAsset;
- (id)modelMesh;
- (id)modelSubmesh;
- (int)objectVersion;
- (BOOL)optOutOfThinning;
- (CGSize)originalUncroppedSize;
- (CGSize)physicalSizeInMeters;
- (BOOL)preserveForArchiveOnly;
- (BOOL)preservedVectorRepresentation;
- (id)provideTextureInfo;
- (id)sizeIndexes;
- (id)sliceInformation;
- (NSUInteger)sourceRowbytes;
- (NSInteger)templateRenderingMode;
- (id)textureImages;
- (NSInteger)textureIntepretation;
- (CGImageRef)uncroppedImage;
- (CGImageRef)unslicedImage;
- (CGSize)unslicedSize;
- (uint16_t)valueForTokenIdentifier:(uint16_t)tokenIdentifier;
- (id)vectorGlyphAvailableSizes;
- (double)vectorGlyphBaseline;
- (double)vectorGlyphCapLine;
- (double)vectorGlyphReferencePointSize;
- (NSInteger)vectorGlyphRenderingMode;
- (float)vectorGlyphTemplateVersion;

@end

CUI_ASSUME_NONNULL_END
