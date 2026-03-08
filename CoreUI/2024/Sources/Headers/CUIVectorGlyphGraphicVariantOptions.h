//
//  CUIVectorGlyphGraphicVariantOptions.h
//  CoreUI
//
//  Audited for 918.3
//  Status: WIP

#import <CoreUI/CUIBase.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

CUI_ASSUME_NONNULL_BEGIN

@interface CUIVectorGlyphGraphicVariantOptions : NSObject <NSCopying>

@property (nonatomic) NSInteger shape;
@property (nonatomic) NSInteger fill;
@property (nonatomic, copy, nullable) NSArray *fillColors;
@property (nonatomic) NSInteger contentEffect;
@property (nonatomic, strong, nullable) CGColorRef monochromeForegroundColor;
@property (nonatomic) CGFloat roundedRectCornerRadius;
@property (nonatomic) NSInteger imageCentering;
@property (nonatomic) NSInteger imageScaling;
@property (nonatomic) NSInteger imageAlignment;
@property (nonatomic) CGSize imageOffset;
@property (nonatomic) NSInteger shapeEffect;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic, strong, nullable) CGColorRef borderColor;

+ (CGFloat)defaultSymbolPointSizeRatio;

- (BOOL)_areValid;

@end

CUI_ASSUME_NONNULL_END
