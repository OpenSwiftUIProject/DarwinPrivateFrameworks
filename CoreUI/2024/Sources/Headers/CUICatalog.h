//
//  CUICatalog.h
//  CoreUI
//
//  Audited for macOS 15.0
//  Status: WIP

#ifndef CUICatalog_h
#define CUICatalog_h

#import <CoreUI/CUIBase.h>
#import <CoreUI/CUIDisplayGamut.h>
#import <CoreUI/CUINamedColor.h>
#import <Foundation/Foundation.h>

CUI_ASSUME_NONNULL_BEGIN

@interface CUICatalog : NSObject
+ (nullable __kindof CUICatalog *)defaultUICatalogForBundle:(nullable NSBundle *)bundle;

- (nullable CUINamedColor *)colorWithName:(NSString *)name displayGamut:(CUIDisplayGamut)gamut deviceIdiom:(NSInteger)idiom appearanceName:(NSString *)appearanceName;
@end

CUI_ASSUME_NONNULL_END

#endif /* CUICatalog_h */
