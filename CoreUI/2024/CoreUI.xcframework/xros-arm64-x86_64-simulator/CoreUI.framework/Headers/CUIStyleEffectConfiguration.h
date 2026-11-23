//
//  CUIStyleEffectConfiguration.h
//  CoreUI
//
//  Audited for 918.3
//  Status: WIP

#ifndef CUIStyleEffectConfiguration_h
#define CUIStyleEffectConfiguration_h

#import <CoreUI/CUIBase.h>
#import <Foundation/Foundation.h>
#import <TargetConditionals.h>

#if TARGET_OS_OSX

CUI_ASSUME_NONNULL_BEGIN

CUI_EXPORT const CFStringRef kCUIBackgroundTypeLight;
CUI_EXPORT const CFStringRef kCUIBackgroundTypeDark;
CUI_EXPORT const CFStringRef kCUIBackgroundTypeBorderless;
CUI_EXPORT const CFStringRef kCUIBackgroundTypeSourceList;
CUI_EXPORT const CFStringRef kCUIBackgroundTypeSelection;

typedef CUI_ENUM(NSInteger, CoreThemeState) {
    kCoreThemeStateNormal = 0,
    kCoreThemeStateRollover = 1,
    kCoreThemeStatePressed = 2,
    obsolete_kCoreThemeStateInactive CUI_SWIFT_NAME(CoreThemeState.obsoleteInactive) = 3,
    kCoreThemeStateDisabled = 4,
    kCoreThemeStateDeeplyPressed = 5,
};

typedef CUI_ENUM(NSInteger, CoreThemePresentationState) {
    kCoreThemePresentationStateActive = 0,
    kCoreThemePresentationStateInactive = 1,
    kCoreThemePresentationStateActiveMain = 2,
};

typedef CUI_ENUM(NSInteger, CoreThemeValue) {
    kCoreThemeValueOff = 0,
    kCoreThemeValueOn = 1,
    kCoreThemeValueMixed = 2,
};

@interface CUIStyleEffectConfiguration : NSObject <NSCopying>
@property (nonatomic) CoreThemeState state;
@property (nonatomic) CoreThemePresentationState presentationState;
@property (nonatomic) CoreThemeValue value;
@property (nonatomic) CGFloat effectScale;
@property (nonatomic) BOOL useSimplifiedEffect;
@property (nonatomic) BOOL foregroundColorShouldTintEffects;
@property (nonatomic) double brightnessMultiplier;
@property (nonatomic) NSUInteger colorTemperature;
@end

@interface CUIBackgroundStyleEffectConfiguration : CUIStyleEffectConfiguration
@property (nonatomic, copy) NSString *backgroundType;
@property (nonatomic) BOOL shouldRespectOutputBlending;
- (void)setSelectionType:(NSInteger)selectionType;
@end

CUI_ASSUME_NONNULL_END

#endif /* TARGET_OS_OSX */
#endif /* CUIStyleEffectConfiguration_h */
