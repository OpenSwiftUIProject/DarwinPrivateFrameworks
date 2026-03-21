//
//  RBDisplayListContents.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>

#if RB_OBJC_FOUNDATION

#include <RenderBox/RBEncodable.h>
#include <RenderBox/RBDecodable.h>
#include <Foundation/Foundation.h>
#include <CoreGraphics/CoreGraphics.h>

RB_ASSUME_NONNULL_BEGIN

struct _RBDrawingState;

@protocol RBDisplayListContents <NSObject, RBEncodable, RBDecodable>

@required

@property (readonly, nonatomic) BOOL empty;
@property (readonly, nonatomic) CGRect boundingRect;
@property (readonly, copy, nonatomic) NSString *xmlDescription;

- (BOOL)isEmpty;
- (void)drawInState:(struct _RBDrawingState *)state;
- (void)renderInContext:(CGContextRef)context options:(nullable id)options;

@optional

@end

RB_ASSUME_NONNULL_END

#endif /* RB_OBJC_FOUNDATION */
