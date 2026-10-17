//
//  CUIVectorGlyphLayer.h
//  CoreUI
//
//  Audited for 918.3
//  Status: WIP

#import <CoreUI/CUIBase.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

CUI_ASSUME_NONNULL_BEGIN

@interface CUIVectorGlyphLayer : NSObject

@property (readonly, nonatomic) CGFloat opacity;
@property (readonly, nonatomic, nullable) NSArray<NSString *> *tags;
@property (readonly, nonatomic, nullable) CGPathRef shape;

@end

CUI_ASSUME_NONNULL_END
