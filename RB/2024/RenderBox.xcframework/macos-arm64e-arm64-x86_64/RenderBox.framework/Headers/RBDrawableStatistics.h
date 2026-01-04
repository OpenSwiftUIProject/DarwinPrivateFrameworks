//
//  RBDrawableStatistics.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>
#include <Foundation/Foundation.h>

RB_ASSUME_NONNULL_BEGIN

@protocol RBDrawableStatistics

@required

@property (readonly, copy, nonatomic, nullable) NSDictionary *statistics;
@property (copy, nonatomic, nullable) id /* block */ statisticsHandler;

- (void)resetStatistics:(NSUInteger)statistics alpha:(double)alpha;

@end

RB_ASSUME_NONNULL_END

