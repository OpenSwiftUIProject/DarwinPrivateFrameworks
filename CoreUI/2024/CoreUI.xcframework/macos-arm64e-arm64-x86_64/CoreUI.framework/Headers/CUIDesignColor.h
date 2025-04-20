//
//  CUIDesignColor.h
//  CoreUI
//
//  Audited for macOS 15.0
//  Status: WIP

#ifndef CUIDesignColor_h
#define CUIDesignColor_h

#import <CoreUI/CUIBase.h>
#import <CoreUI/CUIDisplayGamut.h>

#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CoreGraphics.h>

CUI_ASSUME_NONNULL_BEGIN

@interface CUIDesignColor : NSObject

@property (readonly, nonatomic) CGColorRef cgColor;
@property (readonly, nonatomic) CGBlendMode blendMode;
@property (readonly, nonatomic) CUIDisplayGamut displayGamut;

- (instancetype)initWithColor:(CGColorRef)color blendMode:(CGBlendMode)blendMode displayGamut:(CUIDisplayGamut)displayGamut;

@end

CUI_ASSUME_NONNULL_END

#endif /* CUIDesignColor_h */
