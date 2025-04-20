//
//  CoreUI.h
//  CoreUI
//
//  Audited for macOS 15.0
//  Status: Complete

#import <Foundation/Foundation.h>
#import <CoreUI/CUIBase.h>

CUI_ASSUME_NONNULL_BEGIN

@interface CoreUI : NSObject

+ (void)_determineCompatibilityMode;
+ (NSInteger)coreUICompatibleMode;

@end

CUI_ASSUME_NONNULL_END
