//
//  RBEncoderDelegate.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>
#include <RenderBox/RBEncoderSet.h>
#include <Foundation/Foundation.h>
#include <CoreGraphics/CoreGraphics.h>

RB_ASSUME_NONNULL_BEGIN

@protocol RBEncoderDelegate <NSObject>

@required

@optional

@property (readonly, nonatomic) RBEncoderSet *encoderSet;

- (nullable NSData *)encodedShaderLibraryData:(nullable NSData *)data error:(NSError *_Nullable *_Nullable)error;
- (nullable NSData *)encodedMetadata;
- (nullable NSData *)encodedCGFontData:(CGFontRef)data error:(NSError *_Nullable *_Nullable)error;
- (nullable NSData *)encodedFontData:(nullable NSData *)data cgFont:(CGFontRef)font error:(NSError *_Nullable *_Nullable)error;
- (nullable NSData *)encodedFontSubsetData:(nullable NSData *)data cgFont:(CGFontRef)font error:(NSError *_Nullable *_Nullable)error;
- (nullable NSData *)encodedImageData:(const void *)data error:(NSError *_Nullable *_Nullable)error;
- (BOOL)shouldEncodeFontSubset:(CGFontRef)subset;

@end

RB_ASSUME_NONNULL_END
