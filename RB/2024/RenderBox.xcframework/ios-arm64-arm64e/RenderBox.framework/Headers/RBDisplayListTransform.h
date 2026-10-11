//
//  RBDisplayListTransform.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>

#if RB_OBJC_FOUNDATION

#include <RenderBox/RBColor.h>
#include <RenderBox/RBDisplayListContents.h>
#include <Foundation/Foundation.h>

RB_ASSUME_NONNULL_BEGIN

@interface RBDisplayListTransform : NSObject

- (void)removeAll;
- (void)addColorReplacementFrom:(RBColor)fromColor to:(RBColor)toColor colorSpace:(RBColorSpace)colorSpace;
- (id<RBDisplayListContents>)copyApplyingToDisplayList:(id<RBDisplayListContents>)list;

@end

RB_ASSUME_NONNULL_END

#endif /* RB_OBJC_FOUNDATION */
