//
//  CUINamedColor.h
//  CoreUI
//
//  Audited for 918.3
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
