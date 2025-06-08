//
//  CUIStructuredThemeStore.h
//  CoreUI
//
//  Audited for 918.3
//  Status: WIP

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreUI/CUIBase.h>

CUI_ASSUME_NONNULL_BEGIN

@interface CUIStructuredThemeStore : NSObject

@property BOOL mainBundle;

- (instancetype)initWithBytes:(const void *)bytes length:(NSUInteger)length;
- (instancetype)initWithURL:(id)url;
- (instancetype)initWithPath:(id)path;
- (id)bundleID;
- (id)store;
- (void)setBundleID:(id)bundleID;
- (id)aliasForName:(id)name;
- (BOOL)caAllowSubimageOfImage:(CGImageRef)image;
- (void)clearRenditionCache;
- (NSUInteger)colorSpaceID;
- (id)defaultAppearanceName;
- (NSInteger)deploymentPlatform;
- (id)deploymentPlatformString;
- (BOOL)imageNamedShouldFlip:(id)imageNamedShouldFlip;
- (NSInteger)maximumRenditionKeyTokenCount;
- (id)renditionInfoForIdentifier:(uint16_t)identifier;
- (void)setThemeIndex:(NSUInteger)themeIndex;
- (NSUInteger)themeIndex;
- (id)themeStore;
- (BOOL)usesCUISystemThemeRenditionKey;

@end


CUI_ASSUME_NONNULL_END
