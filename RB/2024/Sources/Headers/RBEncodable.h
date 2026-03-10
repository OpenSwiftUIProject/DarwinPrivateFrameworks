//
//  RBEncodable.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>
#include <Foundation/Foundation.h>

RB_ASSUME_NONNULL_BEGIN

@protocol RBEncoderDelegate;

@protocol RBEncodable <NSObject>

@required

- (nullable NSData *)encodedDataForDelegate:(nullable id<RBEncoderDelegate>)delegate error:(NSError *_Nullable *_Nullable)error;

@optional

@end

RB_ASSUME_NONNULL_END
