//
//  CUICatalog.h
//  CoreUI
//
//  Audited for 918.3
//  Status: WIP

#ifndef CUICatalog_h
#define CUICatalog_h

#import <CoreUI/CUIBase.h>
#import <CoreUI/CUINamedColor.h>
#import <CoreUI/CUITypes.h>
#import <Foundation/Foundation.h>

CUI_ASSUME_NONNULL_BEGIN

@interface CUICatalog : NSObject
+ (nullable __kindof CUICatalog *)defaultUICatalogForBundle:(nullable NSBundle *)bundle;

- (nullable CUINamedColor *)colorWithName:(NSString *)name displayGamut:(CUIDisplayGamut)gamut deviceIdiom:(CUIDeviceIdiom)idiom appearanceName:(NSString *)appearanceName;
@end

CUI_ASSUME_NONNULL_END

#endif /* CUICatalog_h */
