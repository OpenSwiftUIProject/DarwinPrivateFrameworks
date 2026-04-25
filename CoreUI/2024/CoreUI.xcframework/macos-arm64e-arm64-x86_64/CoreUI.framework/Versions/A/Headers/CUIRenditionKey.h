//
//  CUIRenditionKey.h
//  CoreUI
//
//  Audited for 918.3
//  Status: WIP

#import <Foundation/Foundation.h>
#import <CoreUI/CUIBase.h>

CUI_ASSUME_NONNULL_BEGIN

@interface CUIRenditionKey : NSObject <NSCopying, NSCoding>

@property (nonatomic) NSInteger themeElement;
@property (nonatomic) NSInteger themePart;
@property (nonatomic) NSInteger themeSize;
@property (nonatomic) NSInteger themeDirection;
@property (nonatomic) NSInteger themeValue;
@property (nonatomic) NSInteger themePreviousValue;
@property (nonatomic) NSInteger themeDimension1;
@property (nonatomic) NSInteger themeDimension2;
@property (nonatomic) NSInteger themeState;
@property (nonatomic) NSInteger themePreviousState;
@property (nonatomic) NSInteger themePresentationState;
@property (nonatomic) NSInteger themeLayer;
@property (nonatomic) NSInteger themeScale;
@property (nonatomic) NSInteger themeIdiom;
@property (nonatomic) NSInteger themeSubtype;
@property (nonatomic) NSInteger themeSizeClassHorizontal;
@property (nonatomic) NSInteger themeSizeClassVertical;
@property (nonatomic) NSInteger themeMemoryClass;
@property (nonatomic) NSInteger themeGraphicsClass;
@property (nonatomic) NSInteger themeIdentifier;
@property (nonatomic) NSInteger themeAppearance;
@property (nonatomic) NSInteger themeLocalization;
@property (nonatomic) NSInteger themeDisplayGamut;
@property (nonatomic) NSInteger themeDeploymentTarget;
@property (nonatomic) NSInteger themeGlyphSize;
@property (nonatomic) NSInteger themeGlyphWeight;

+ (instancetype)renditionKey;
- (instancetype)initWithThemeElement:(NSInteger)themeElement themePart:(NSInteger)themePart themeSize:(NSInteger)themeSize themeDirection:(NSInteger)themeDirection themeValue:(NSInteger)themeValue themeDimension1:(NSInteger)themeDimension1 themeDimension2:(NSInteger)themeDimension2 themeState:(NSInteger)themeState themePresentationState:(NSInteger)themePresentationState themeLayer:(NSInteger)themeLayer themeScale:(NSInteger)themeScale themeIdentifier:(NSInteger)themeIdentifier;

@end


CUI_ASSUME_NONNULL_END
