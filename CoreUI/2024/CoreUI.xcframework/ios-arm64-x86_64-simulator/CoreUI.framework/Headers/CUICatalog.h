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
#import <CoreUI/CUINamedImage.h>
#import <CoreUI/CUINamedVectorGlyph.h>
#import <CoreUI/CUITypes.h>
#import <Foundation/Foundation.h>

CUI_ASSUME_NONNULL_BEGIN

@interface CUICatalog : NSObject

// MARK: - Class Methods

+ (nullable __kindof CUICatalog *)defaultUICatalogForBundle:(nullable NSBundle *)bundle;

// MARK: - Initializers

- (nullable instancetype)initWithName:(NSString *)name fromBundle:(NSBundle *)bundle;
- (nullable instancetype)initWithName:(NSString *)name fromBundle:(NSBundle *)bundle error:(NSError **)error;
- (nullable instancetype)initWithURL:(NSURL *)url error:(NSError **)error;

// MARK: - Color Lookup

- (nullable CUINamedColor *)colorWithName:(NSString *)name
                              displayGamut:(CUIDisplayGamut)gamut
                               deviceIdiom:(CUIDeviceIdiom)idiom
                            appearanceName:(NSString *)appearanceName;

// MARK: - Image Lookup

- (BOOL)imageExistsWithName:(NSString *)name;

- (nullable CUINamedImage *)imageWithName:(NSString *)name
                              scaleFactor:(CGFloat)scaleFactor
                              deviceIdiom:(CUIDeviceIdiom)idiom
                            deviceSubtype:(CUISubtype)subtype
                             displayGamut:(CUIDisplayGamut)gamut
                          layoutDirection:(CUILayoutDirection)layoutDirection
                    sizeClassHorizontal:(CUIUserInterfaceSizeClass)horizontalSizeClass
                      sizeClassVertical:(CUIUserInterfaceSizeClass)verticalSizeClass
                           appearanceName:(nullable NSString *)appearanceName;

- (nullable CUINamedImage *)imageWithName:(NSString *)name
                              scaleFactor:(CGFloat)scaleFactor
                              deviceIdiom:(CUIDeviceIdiom)idiom
                            deviceSubtype:(CUISubtype)subtype
                             displayGamut:(CUIDisplayGamut)gamut
                          layoutDirection:(CUILayoutDirection)layoutDirection
                    sizeClassHorizontal:(CUIUserInterfaceSizeClass)horizontalSizeClass
                      sizeClassVertical:(CUIUserInterfaceSizeClass)verticalSizeClass
                           appearanceName:(nullable NSString *)appearanceName
                                   locale:(nullable NSString *)locale;

// MARK: - Named Vector Glyph Lookup

- (nullable CUINamedVectorGlyph *)namedVectorGlyphWithName:(NSString *)name
                                               scaleFactor:(CGFloat)scaleFactor
                                               deviceIdiom:(CUIDeviceIdiom)idiom
                                           layoutDirection:(CUILayoutDirection)layoutDirection
                                                 glyphSize:(NSInteger)glyphSize
                                               glyphWeight:(_CUIThemeVectorGlyphWeight)glyphWeight
                                            glyphPointSize:(CGFloat)glyphPointSize
                                            appearanceName:(nullable NSString *)appearanceName;

- (nullable CUINamedVectorGlyph *)namedVectorGlyphWithName:(NSString *)name
                                               scaleFactor:(CGFloat)scaleFactor
                                               deviceIdiom:(CUIDeviceIdiom)idiom
                                           layoutDirection:(CUILayoutDirection)layoutDirection
                                                 glyphSize:(NSInteger)glyphSize
                                               glyphWeight:(_CUIThemeVectorGlyphWeight)glyphWeight
                                            glyphPointSize:(CGFloat)glyphPointSize
                                            appearanceName:(nullable NSString *)appearanceName
                                                    locale:(nullable NSLocale *)locale;

- (nullable CUINamedVectorGlyph *)namedVectorGlyphWithName:(NSString *)name
                                               scaleFactor:(CGFloat)scaleFactor
                                               deviceIdiom:(CUIDeviceIdiom)idiom
                                           layoutDirection:(CUILayoutDirection)layoutDirection
                                      glyphContinuousSize:(CGFloat)glyphContinuousSize
                                    glyphContinuousWeight:(CGFloat)glyphContinuousWeight
                                            glyphPointSize:(CGFloat)glyphPointSize
                                            appearanceName:(nullable NSString *)appearanceName
                                                    locale:(nullable NSLocale *)locale;

// MARK: - Named Lookup (Generic)

- (nullable CUINamedLookup *)namedLookupWithName:(NSString *)name
                                     scaleFactor:(CGFloat)scaleFactor
                                     deviceIdiom:(CUIDeviceIdiom)idiom
                                   deviceSubtype:(CUISubtype)subtype
                                    displayGamut:(CUIDisplayGamut)gamut
                                 layoutDirection:(CUILayoutDirection)layoutDirection
                           sizeClassHorizontal:(CUIUserInterfaceSizeClass)horizontalSizeClass
                             sizeClassVertical:(CUIUserInterfaceSizeClass)verticalSizeClass
                                  appearanceName:(nullable NSString *)appearanceName
                                          locale:(nullable NSString *)locale;

// MARK: - Utility

- (BOOL)containsLookupForName:(NSString *)name;
- (nullable NSArray<NSString *> *)allImageNames;
- (void)clearCachedImageResources;
- (void)enumerateNamedLookupsUsingBlock:(void (^)(CUINamedLookup *lookup))block;

@end

CUI_ASSUME_NONNULL_END

#endif /* CUICatalog_h */
