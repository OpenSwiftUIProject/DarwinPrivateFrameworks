//
//  RBSymbolAnimatorObserver.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>

#if RB_OBJC_FOUNDATION

#include <Foundation/Foundation.h>

RB_ASSUME_NONNULL_BEGIN

@class RBSymbolAnimator;

@protocol RBSymbolAnimatorObserver <NSObject>

@required

- (void)symbolAnimatorDidChange:(RBSymbolAnimator *)animator;

@optional

@end

RB_ASSUME_NONNULL_END

#endif /* RB_OBJC_FOUNDATION */
