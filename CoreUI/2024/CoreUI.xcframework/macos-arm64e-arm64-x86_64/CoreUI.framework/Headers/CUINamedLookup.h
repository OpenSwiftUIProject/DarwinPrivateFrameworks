//
//  CUINamedLookup.h
//  CoreUI
//
//  Audited for macOS 15.0
//  Status: Complete

#import <Foundation/Foundation.h>
#import <CoreUI/CUIRenditionKey.h>
#import <CoreUI/CUIBase.h>

CUI_ASSUME_NONNULL_BEGIN

@interface CUINamedLookup : NSObject <NSLocking>

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) CUIRenditionKey *key;
@property (nonatomic) NSUInteger storageRef;

@property (readonly, nonatomic) CUIRenditionKey *renditionKey;
@property (readonly, nonatomic) NSString *keySignature;
@property (readonly, nonatomic) NSUInteger subtype;
@property (readonly, nonatomic) NSInteger sizeClassHorizontal;
@property (readonly, nonatomic) NSInteger sizeClassVertical;
@property (readonly, nonatomic) NSInteger memoryClass;
@property (readonly, nonatomic) NSInteger graphicsClass;
@property (readonly, nonatomic) NSInteger appearanceIdentifier;
@property (readonly, nonatomic) NSString *renditionName;
@property (readonly, nonatomic) BOOL representsOnDemandContent;
@property (readonly, nonatomic) NSInteger idiom;
@property (readonly, nonatomic) NSInteger displayGamut;
@property (readonly, nonatomic) NSInteger layoutDirection;
@property (readonly, nonatomic) NSInteger localization;
@property (readonly, nonatomic) NSString *appearance;

- (nullable instancetype)initWithName:(NSString *)name usingRenditionKey:(CUIRenditionKey *)renditionKey fromTheme:(NSUInteger)theme;
- (BOOL)isTintable;
- (void)setRepresentsOnDemandContent:(BOOL)demandContent;

@end

CUI_ASSUME_NONNULL_END
