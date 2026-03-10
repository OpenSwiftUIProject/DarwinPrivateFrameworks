//
//  RBDecodable.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>
#include <Foundation/Foundation.h>

RB_ASSUME_NONNULL_BEGIN

@protocol RBDecoderDelegate;

@protocol RBDecodable <NSObject>

@required

+ (nullable id)decodedObjectWithData:(NSData *)data delegate:(nullable id<RBDecoderDelegate>)delegate error:(NSError *_Nullable *_Nullable)error;

@optional

@end

RB_ASSUME_NONNULL_END
