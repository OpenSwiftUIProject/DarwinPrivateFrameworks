//
//  RBDecoderDelegate.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>

#if RB_OBJC_FOUNDATION

#include <Foundation/Foundation.h>
#include <CoreGraphics/CoreGraphics.h>

RB_ASSUME_NONNULL_BEGIN

@protocol RBDecoderDelegate <NSObject>

@required

@optional

- (CGFontRef)decodedCGFontWithData:(nullable NSData *)data error:(NSError *_Nullable *_Nullable)error;
- (nullable void *)decodedImageContentsWithData:(nullable NSData *)data type:(int *_Nullable)type error:(NSError *_Nullable *_Nullable)error;
- (void)decodedMetadata:(nullable NSData *)metadata;
- (nullable id)decodedShaderLibraryWithData:(nullable NSData *)data error:(NSError *_Nullable *_Nullable)error;

@end

RB_ASSUME_NONNULL_END

#endif /* RB_OBJC_FOUNDATION */
