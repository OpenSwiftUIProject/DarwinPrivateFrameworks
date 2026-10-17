//
//  RBDisplayListPredicate.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>

#if RB_OBJC_FOUNDATION

#include <RenderBox/RBColor.h>
#include <RenderBox/RBDisplayListContents.h>
#include <Foundation/Foundation.h>

RB_ASSUME_NONNULL_BEGIN

@interface RBDisplayListPredicate : NSObject

@property (nonatomic) BOOL invertsResult;

- (void)removeAll;
- (void)addConditionWithFillColor:(RBColor)color colorSpace:(RBColorSpace)colorSpace;
- (id<RBDisplayListContents>)copyFilteredDisplayList:(id<RBDisplayListContents>)list;

@end

RB_ASSUME_NONNULL_END

#endif /* RB_OBJC_FOUNDATION */
