//
//  RBDisplayList.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>
#include <RenderBox/RBDisplayListContents.h>
#include <RenderBox/RBColor.h>
#include <RenderBox/RBColorSpace.h>
#include <Foundation/Foundation.h>
#include <CoreGraphics/CoreGraphics.h>

RB_ASSUME_NONNULL_BEGIN

@interface RBDisplayList : NSObject <RBDisplayListContents>

@property (nonatomic) BOOL linearColors;
@property (nonatomic) unsigned int profile;
@property (nonatomic) CGRect contentRect;
@property (nonatomic) double deviceScale;
@property (readonly, nonatomic) CGRect clipBoundingBox;
@property (nonatomic) CGAffineTransform CTM;
@property (nonatomic) RBColorSpace defaultColorSpace;
@property (readonly, nonatomic) unsigned int identifier;
@property (readonly, copy, nonatomic, nullable) NSUUID *identifierNamespace;
@property (readonly, nonatomic) BOOL empty;
@property (readonly, nonatomic) CGRect boundingRect;
@property (readonly, copy, nonatomic) NSString *xmlDescription;

- (BOOL)isEmpty;
- (void)clearCaches;
- (void)clear;
- (nullable id)valueForAttribute:(unsigned int)attribute;
- (void)save;
- (void)restore;
- (void)setValue:(nullable id)value forAttribute:(unsigned int)attribute;
- (void)concat:(CGAffineTransform)transform;
- (void)translateByX:(double)x Y:(double)y;
- (void)scaleByX:(double)x Y:(double)y;
- (void)rotateBy:(double)angle;
- (CGContextRef)beginCGContextWithAlpha:(float)alpha;
- (CGContextRef)beginCGContextWithAlpha:(float)alpha flags:(unsigned int)flags;
- (void)endCGContext;
- (void)beginLayer;
- (void)beginLayerWithFlags:(unsigned int)flags;
- (void)drawLayerWithAlpha:(float)alpha blendMode:(int)mode;
- (void)clipLayerWithAlpha:(float)alpha mode:(int)mode;
- (void)clipShape:(id)shape mode:(int)mode;
- (void)clipShape:(id)shape alpha:(float)alpha mode:(int)mode;
- (void)drawShape:(id)shape fill:(id)fill alpha:(float)alpha blendMode:(int)mode;
- (void)drawDisplayList:(id<RBDisplayListContents>)list;
- (void)drawDisplayList:(id<RBDisplayListContents>)list alpha:(float)alpha;
- (void)drawInRect:(CGRect)rect alpha:(float)alpha blendMode:(int)mode flags:(unsigned int)flags operation:(id /* block */)operation;
- (void)drawInState:(struct _RBDrawingState *)state;
- (void)renderInContext:(CGContextRef)context options:(nullable id)options;
- (nullable id<RBDisplayListContents>)moveContents;
- (void)setIdentifier:(unsigned int)identifier namespace:(nullable NSUUID *)ns;
- (void)beginRecordingXML;
- (void)addAffineTransformStyle:(CGAffineTransform)style;
- (void)addTranslationStyleWithOffset:(CGSize)offset;
- (void)addScaleStyleWithScale:(CGSize)scale anchor:(CGPoint)anchor;
- (void)addRotationStyleWithAngle:(double)angle anchor:(CGPoint)anchor;
- (void)addProjectionStyleWithArray:(float[_Nonnull 9])array;
- (void)addTransformStyle:(id)style;
- (void)addPredicateStyle:(id)style;
- (void)addAnimationStyle:(id)style id:(NSUUID *)styleID;
- (void)addAnimationStyle:(id)style id:(NSUUID *)styleID flags:(unsigned int)flags;
- (void)addBlurFilterWithRadius:(double)radius;
- (void)addBlurFilterWithRadius:(double)radius opaque:(BOOL)opaque;
- (void)addBlurFilterWithRadius:(double)radius flags:(unsigned int)flags;
- (void)addBlurFilterWithRadius:(double)radius bounds:(CGRect)bounds flags:(unsigned int)flags;
- (void)addVariableBlurFilterWithRadius:(double)radius mask:(id)mask bounds:(CGRect)bounds flags:(unsigned int)flags;
- (void)addVariableBlurLayerWithAlpha:(float)alpha scale:(double)scale radius:(double)radius bounds:(CGRect)bounds flags:(unsigned int)flags;
- (void)addBrightnessFilterWithAmount:(float)amount;
- (void)addBrightnessFilterWithAmount:(float)amount flags:(unsigned int)flags;
- (void)addContrastFilterWithAmount:(float)amount;
- (void)addContrastFilterWithAmount:(float)amount flags:(unsigned int)flags;
- (void)addGrayscaleFilterWithAmount:(float)amount;
- (void)addGrayscaleFilterWithAmount:(float)amount flags:(unsigned int)flags;
- (void)addHueRotationFilterWithAngle:(double)angle;
- (void)addHueRotationFilterWithAngle:(double)angle flags:(unsigned int)flags;
- (void)addSaturationFilterWithAmount:(float)amount;
- (void)addSaturationFilterWithAmount:(float)amount flags:(unsigned int)flags;
- (void)addColorInvertFilter;
- (void)addColorInvertFilterWithAmount:(float)amount flags:(unsigned int)flags;
- (void)addColorMatrixFilterWithArray:(float[_Nonnull 20])array;
- (void)addColorMatrixFilterWithArray:(float[_Nonnull 20])array flags:(unsigned int)flags;
- (void)addColorMultiplyFilterWithColor:(RBColor)color;
- (void)addColorMultiplyFilterWithColor:(RBColor)color colorSpace:(int)space flags:(unsigned int)flags;
- (void)addColorMonochromeFilterWithAmount:(float)amount color:(RBColor)color bias:(float)bias;
- (void)addColorMonochromeFilterWithAmount:(float)amount color:(RBColor)color colorSpace:(int)space bias:(float)bias flags:(unsigned int)flags;
- (void)addAlphaMultiplyFilterWithColor:(RBColor)color;
- (void)addAlphaMultiplyFilterWithColor:(RBColor)color colorSpace:(int)space flags:(unsigned int)flags;
- (void)addAlphaThresholdFilterWithAlpha:(float)alpha color:(RBColor)color colorSpace:(int)space;
- (void)addAlphaThresholdFilterWithMinAlpha:(float)minAlpha maxAlpha:(float)maxAlpha color:(RBColor)color colorSpace:(int)space;
- (void)addAlphaGradientFilterWithStopCount:(long long)count colors:(const RBColor *)colors colorSpace:(int)space locations:(const double *)locations flags:(unsigned int)flags;
- (void)addLuminanceToAlphaFilter;
- (void)addLuminanceToAlphaFilterWithFlags:(unsigned int)flags;
- (void)addLuminanceCurveFilterWithCurve:(float[_Nonnull 4])curve color:(RBColor)color colorSpace:(int)space flags:(unsigned int)flags;
- (void)addRGBACurvesFilterWithCurves:(float[_Nonnull 16])curves flags:(unsigned int)flags;
- (void)addDistanceFilterWithMaxDistance:(double)distance scale:(double)scale flags:(unsigned int)flags;
- (void)addFilterWithShader:(id)shader border:(CGSize)border bounds:(const CGRect *_Nullable)bounds flags:(unsigned int)flags;
- (void)addFilterLayerWithShader:(id)shader border:(CGSize)border layerBorder:(CGSize)layerBorder bounds:(const CGRect *_Nullable)bounds flags:(unsigned int)flags;
- (void)addShadowStyleWithRadius:(double)radius offset:(CGSize)offset color:(RBColor)color mode:(unsigned int)mode;
- (void)addShadowStyleWithRadius:(double)radius offset:(CGSize)offset color:(RBColor)color colorSpace:(int)space blendMode:(int)mode flags:(unsigned int)flags;
- (void)addShadowStyleWithRadius:(double)radius midpoint:(float)midpoint offset:(CGSize)offset color:(RBColor)color colorSpace:(int)space blendMode:(int)mode flags:(unsigned int)flags;
- (void)addRotation3DStyleWithAngle:(double)angle axis:(struct { float x; float y; float z; })axis anchor:(struct { float x; float y; float z; })anchor perspective:(double)perspective flipWidth:(double)width;
- (void)addPathProjectionStyleWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint path:(id)path transform:(CGAffineTransform)transform flags:(unsigned int)flags;
- (nullable NSData *)encodedDataForDelegate:(nullable id)delegate error:(NSError *_Nullable *_Nullable)error;

@end

RB_ASSUME_NONNULL_END
