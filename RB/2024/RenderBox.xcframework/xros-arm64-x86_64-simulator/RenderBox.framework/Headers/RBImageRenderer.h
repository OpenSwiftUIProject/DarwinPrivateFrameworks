//
//  RBImageRenderer.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>
#include <Foundation/Foundation.h>
#include <CoreGraphics/CoreGraphics.h>

RB_ASSUME_NONNULL_BEGIN

@protocol RBImageRenderer <NSObject>

@required

- (nullable CGImageRef)renderImageInRect:(CGRect)rect options:(nullable id)options renderer:(nullable id /* block */)renderer;
- (void)renderImageInRect:(CGRect)rect options:(nullable id)options renderer:(nullable id /* block */)renderer completionQueue:(nullable id)queue handler:(nullable id /* block */)handler;

@end

RB_ASSUME_NONNULL_END

