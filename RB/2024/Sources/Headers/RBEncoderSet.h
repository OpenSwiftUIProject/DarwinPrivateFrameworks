//
//  RBEncoderSet.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>

#if RB_OBJC_FOUNDATION

#include <Foundation/Foundation.h>

RB_ASSUME_NONNULL_BEGIN

@interface RBEncoderSet : NSObject

- (instancetype)init;
- (void)commit;
- (void)addDisplayList:(id)list;

@end

RB_ASSUME_NONNULL_END

#endif /* RB_OBJC_FOUNDATION */
