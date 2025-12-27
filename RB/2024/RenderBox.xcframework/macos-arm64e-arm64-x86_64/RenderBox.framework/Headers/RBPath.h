//
//  RBPath.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>
#include <CoreGraphics/CoreGraphics.h>

RB_ASSUME_NONNULL_BEGIN

RB_EXTERN_C_BEGIN

/// Path element type for path enumeration
typedef RB_ENUM(int32_t, RBPathElement) {
    RBPathElementMoveToPoint = 0,
    RBPathElementAddLineToPoint = 1,
    RBPathElementAddQuadCurveToPoint = 2,
    RBPathElementAddCurveToPoint = 3,
    RBPathElementCloseSubpath = 4,
    RBPathElementRect = 5,
    RBPathElementRoundedRect = 6,
    RBPathElementFixedRoundedRectCircular = 8,
    RBPathElementFixedRoundedRectContinuous = 9,

    RBPathElementInvalid = 25,
} RB_SWIFT_NAME(RBPath.Element);

/// Defines the shape of a rounded rectangle's corners.
typedef RB_ENUM(int32_t, RBPathRoundedCornerStyle) {
    /// Quarter-circle rounded rect corners.
    RBPathRoundedCornerStyleCircular = 0,
    /// Continuous curvature rounded rect corners.
    RBPathRoundedCornerStyleContinuous = 1,
} RB_SWIFT_NAME(RBPath.RoundedCornerStyle);

/// Callback type for path element enumeration
/// Returns true to stop enumeration, false to continue
typedef bool (*RBPathApplyCallback)(void * info, RBPathElement element, const CGFloat *points, const void * _Nullable userInfo);

typedef struct RBPathCallbacks RBPathCallbacks RB_SWIFT_NAME(RBPath.ApplyCallback);

typedef struct RBPathStorage * RBPathStorageRef RB_SWIFT_STRUCT RB_SWIFT_NAME(RBPath.Storage);

typedef struct RBPath {
    RBPathStorageRef storage;
    const RBPathCallbacks * callbacks;
} RBPath;

/// Global empty path (storage = null, callbacks = &RBPathEmptyCallbacks)
RB_EXPORT
const RBPath RBPathEmpty RB_SWIFT_NAME(RBPath.empty);

/// Global null path (storage = 0x1, callbacks = &RBPathEmptyCallbacks)
RB_EXPORT
const RBPath RBPathNull RB_SWIFT_NAME(RBPath.null);

RB_EXPORT
void RBPathRetain(RBPath path) RB_SWIFT_NAME(RBPath.retain(self:));

RB_EXPORT
void RBPathRelease(RBPath path) RB_SWIFT_NAME(RBPath.release(self:));

// MARK: - Path Creation

RB_EXPORT
RBPath RBPathMakeWithCGPath(CGPathRef cgPath) RB_SWIFT_NAME(RBPath.init(cgPath:));

RB_EXPORT
RBPath RBPathMakeRect(CGRect rect, const CGAffineTransform * _Nullable transform) RB_SWIFT_NAME(RBPath.init(rect:transform:));

RB_EXPORT
RBPath RBPathMakeEllipse(CGRect rect, const CGAffineTransform * _Nullable transform) RB_SWIFT_NAME(RBPath.init(ellipseIn:transform:));

RB_EXPORT
RBPath RBPathMakeRoundedRect(CGRect rect, CGFloat cornerWidth, CGFloat cornerHeight, RBPathRoundedCornerStyle style, const CGAffineTransform * _Nullable transform) RB_SWIFT_NAME(RBPath.init(roundedRect:cornerWidth:cornerHeight:style:transform:));

RB_EXPORT
RBPath RBPathMakeUnevenRoundedRect(CGRect rect, CGFloat topLeftRadius, CGFloat bottomLeftRadius, CGFloat bottomRightRadius, CGFloat topRightRadius, RBPathRoundedCornerStyle style, const CGAffineTransform * _Nullable transform) RB_SWIFT_NAME(RBPath.init(roundedRect:topLeftRadius:bottomLeftRadius:bottomRightRadius:topRightRadius:style:transform:));

// MARK: - Path Operation

RB_EXPORT
bool RBPathIsEmpty(RBPath path) RB_SWIFT_NAME(getter:RBPath.isEmpty(self:));

RB_EXPORT
bool RBPathApplyElements(RBPath path, void * info, _Nullable RBPathApplyCallback callback) RB_SWIFT_NAME(RBPath.apply(self:info:callback:));

RB_EXPORT
bool RBPathEqualToPath(RBPath lhs, RBPath rhs) RB_SWIFT_NAME(RBPath.isEqual(self:to:));

// MARK: - CGPath Interoperability

RB_EXPORT
CGPathRef RBPathCopyCGPath(RBPath path) RB_SWIFT_NAME(getter:RBPath.cgPath(self:));

// MARK: - Point Containment

RB_EXPORT
bool RBPathContainsPoint(RBPath path, CGPoint point, bool eoFill) RB_SWIFT_NAME(RBPath.contains(self:point:eoFill:));

RB_EXPORT
bool RBPathContainsPoints(RBPath path, uint64_t count, const CGPoint *points, bool eoFill, const CGAffineTransform * _Nullable transform) RB_SWIFT_NAME(RBPath.containsPoints(self:count:points:eoFill:transform:));

RB_EXTERN_C_END

RB_ASSUME_NONNULL_END
