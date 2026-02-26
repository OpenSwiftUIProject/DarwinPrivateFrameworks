//
//  CUINamedVectorGlyph.h
//  CoreUI
//
//  Audited for 918.3
//  Status: WIP

#import <CoreUI/CUIBase.h>
#import <CoreUI/CUITypes.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

CUI_ASSUME_NONNULL_BEGIN

@class CUICatalog;

@interface CUINamedVectorGlyph : NSObject

@property (readonly, nonatomic, nullable) CGImageRef image;
@property (readonly, nonatomic) CGFloat scale;
@property (readonly, nonatomic, nullable) CGPathRef CGPath;
@property (readonly, nonatomic) NSInteger layoutDirection;
@property (readonly, nonatomic) CGFloat pointSize;
@property (readonly, nonatomic) NSInteger glyphSize;
@property (readonly, nonatomic) NSInteger glyphWeight;
@property (readonly, nonatomic) CGFloat glyphContinuousSize;
@property (readonly, nonatomic) CGFloat glyphContinuousWeight;
@property (readonly, nonatomic) BOOL isFlippable;
@property (readonly, nonatomic) float templateVersion;

@property (readonly, nonatomic) CGRect alignmentRect;
@property (readonly, nonatomic) CGRect alignmentRectUnrounded;
@property (readonly, nonatomic) CGFloat baselineOffset;
@property (readonly, nonatomic) CGFloat baselineOffsetUnrounded;
@property (readonly, nonatomic) CGFloat capHeight;
@property (readonly, nonatomic) CGFloat capHeightUnrounded;
@property (readonly, nonatomic) CGRect contentBounds;
@property (readonly, nonatomic) CGRect contentBoundsUnrounded;
@property (readonly, nonatomic) CGRect interiorAlignmentRect;
@property (readonly, nonatomic) CGRect interiorAlignmentRectUnrounded;
@property (readonly, nonatomic) CGPoint metricCenter;
@property (readonly, nonatomic) CGSize referenceCanvasSize;
@property (readonly, nonatomic) CGFloat referencePointSize;
@property (readonly, nonatomic) CGPoint rotationAnchor;

@property (readonly, nonatomic) NSInteger preferredRenderingMode;

@property (readonly, nonatomic) NSInteger numberOfHierarchyLayers;
@property (readonly, nonatomic) NSInteger numberOfTemplateLayers;
@property (readonly, nonatomic) NSInteger numberOfMulticolorLayers;
@property (readonly, nonatomic) NSInteger numberOfPaletteLayers;

@property (readonly, nonatomic) CGFloat variableMinValue;
@property (readonly, nonatomic) CGFloat variableMaxValue;
- (void)setVariableMinValue:(CGFloat)value;
- (void)setVariableMaxValue:(CGFloat)value;

- (CGRect)alignmentRectForTargetSize:(CGSize)targetSize scale:(CGFloat)scale;
- (CGRect)interiorAlignmentRectForTargetSize:(CGSize)targetSize scale:(CGFloat)scale;

- (nullable CGImageRef)rasterizeImageUsingScaleFactor:(CGFloat)scaleFactor forTargetSize:(CGSize)targetSize;

- (nullable CGImageRef)imageWithHierarchicalPrimaryColor:(CGColorRef)color;
- (nullable CGImageRef)imageWithPaletteColors:(NSArray *)colors;

- (nullable instancetype)initWithName:(NSString *)name
                          scaleFactor:(CGFloat)scaleFactor
                          deviceIdiom:(CUIDeviceIdiom)idiom
                            pointSize:(CGFloat)pointSize
                     continuousWeight:(CGFloat)continuousWeight
                       continuousSize:(CGFloat)continuousSize
              interpolatedFromRegular:(nullable id)regular
                           ultralight:(nullable id)ultralight
                                black:(nullable id)black
                          fromCatalog:(CUICatalog *)catalog
                             themeRef:(NSUInteger)themeRef;

- (nullable instancetype)initWithName:(NSString *)name
                          scaleFactor:(CGFloat)scaleFactor
                          deviceIdiom:(CUIDeviceIdiom)idiom
                            pointSize:(CGFloat)pointSize
                     continuousWeight:(CGFloat)continuousWeight
                       continuousSize:(CGFloat)continuousSize
              interpolatedFromRegular:(nullable id)regular
                           ultralight:(nullable id)ultralight
                                black:(nullable id)black
                          fromCatalog:(CUICatalog *)catalog
                             themeRef:(NSUInteger)themeRef
                               locale:(nullable NSString *)locale;

@end

CUI_ASSUME_NONNULL_END
