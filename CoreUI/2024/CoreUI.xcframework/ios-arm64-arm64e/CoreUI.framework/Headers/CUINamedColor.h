//
//  CUINamedColor.h
//  CoreUI
//
//  Audited for macOS 15.0
//  Status: Complete

#import <CoreUI/CUIBase.h>
#import <CoreUI/CUINamedLookup.h>
#import <CoreGraphics/CoreGraphics.h>

CUI_ASSUME_NONNULL_BEGIN

@interface CUINamedColor : CUINamedLookup

@property (readonly, nonatomic, nullable) CGColorRef cgColor;
@property (readonly, nonatomic) BOOL substituteWithSystemColor;
@property (readonly, nonatomic) NSString *systemColorName;

@end

CUI_ASSUME_NONNULL_END
