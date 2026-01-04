//
//  _RBDrawableDelegate.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>
#include <Foundation/Foundation.h>

RB_ASSUME_NONNULL_BEGIN

@protocol _RBDrawableDelegate <NSObject>

@required

- (void)_RBDrawableStatisticsDidChange;

@optional

@end

RB_ASSUME_NONNULL_END

