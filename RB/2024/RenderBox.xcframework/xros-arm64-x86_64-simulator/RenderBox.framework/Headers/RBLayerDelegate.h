//
//  RBLayerDelegate.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>
#include <RenderBox/RBDisplayList.h>
#include <Foundation/Foundation.h>
#include <QuartzCore/QuartzCore.h>

RB_ASSUME_NONNULL_BEGIN

@class RBLayer;

@protocol RBLayerDelegate <CALayerDelegate>

@required

@optional

- (void)RBLayer:(RBLayer *)layer draw:(RBDisplayList *)inDisplayList;
- (nullable id)RBLayerDefaultDevice:(RBLayer *)layer;

@end

RB_ASSUME_NONNULL_END

