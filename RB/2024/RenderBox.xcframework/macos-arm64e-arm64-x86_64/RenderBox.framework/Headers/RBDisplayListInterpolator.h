//
//  RBDisplayListInterpolator.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>
#include <RenderBox/RBDisplayListContents.h>
#include <Foundation/Foundation.h>
#include <CoreGraphics/CoreGraphics.h>

RB_ASSUME_NONNULL_BEGIN

@interface RBDisplayListInterpolator : NSObject <NSCopying>

@property (retain, nonatomic) id<RBDisplayListContents> from;
@property (readonly, nonatomic) id<RBDisplayListContents> to;
@property (readonly, copy, nonatomic, nullable) NSDictionary *options;
@property (readonly, nonatomic, getter=isIdentity) BOOL identity;
@property (readonly, nonatomic) BOOL onlyFades;
@property (readonly, nonatomic) double activeDuration;

+ (instancetype)interpolatorWithFrom:(id<RBDisplayListContents>)from to:(id<RBDisplayListContents>)to options:(nullable NSDictionary *)options;

- (instancetype)initWithFrom:(id<RBDisplayListContents>)from to:(id<RBDisplayListContents>)to options:(nullable NSDictionary *)options;
- (id)copyWithZone:(nullable NSZone *)zone;
- (void)drawInState:(void *)state by:(float)by;
- (CGRect)boundingRectWithProgress:(float)progress;
- (nullable id<RBDisplayListContents>)contentsWithProgress:(float)progress;
- (nullable id<RBDisplayListContents>)copyContentsWithProgress:(float)progress;
- (double)maxAbsoluteVelocityWithProgress:(float)progress;

@end

RB_ASSUME_NONNULL_END
