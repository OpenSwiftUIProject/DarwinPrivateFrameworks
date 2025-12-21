//
//  RBPath.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>
#include <CoreGraphics/CoreGraphics.h>

RB_ASSUME_NONNULL_BEGIN

RB_IMPLICIT_BRIDGING_ENABLED

RB_EXTERN_C_BEGIN

typedef struct RB_BRIDGED_TYPE(id) RBPath * RBMutablePathRef;
typedef const struct RB_BRIDGED_TYPE(id) RBPath * RBPathRef;

typedef struct RB_BRIDGED_TYPE(id) RBPathStorage * RBPathStorageRef RB_SWIFT_NAME(RBPath.Storage);
typedef const struct RB_BRIDGED_TYPE(id) RBPathCallbacks * RBPathCallbacksRef RB_SWIFT_NAME(RBPath.Callbacks);

struct RBPath;
struct RBPathStorage;
struct RBPathCallbacks;

/// Path element type for path enumeration
typedef RB_ENUM(int32_t, RBPathElementType) {
    RBPathElementMoveToPoint = 0,
    RBPathElementAddLineToPoint = 1,
    RBPathElementAddQuadCurveToPoint = 2,
    RBPathElementAddCurveToPoint = 3,
    RBPathElementCloseSubpath = 4,
};

/// An element of a path returned by path enumeration
struct RBPathElement {
    RBPathElementType type;
    const double * _Nullable points;
};
typedef struct RBPathElement RBPathElement;

/// Callback type for path element enumeration
/// Returns true to stop enumeration, false to continue
typedef bool (*RBPathApplyCallback)(void * _Nullable info, RBPathElement element, const void * _Nullable userInfo);

typedef struct RBPath {
    RBPathStorageRef _Nullable storage;
    RBPathCallbacksRef _Nullable callbacks;
} RBPath;

/// Global empty path (storage = null, callbacks = &RBPathEmptyCallbacks)
RB_EXPORT
const RBPath RBPathEmpty;

/// Global null path (storage = 0x1, callbacks = &RBPathEmptyCallbacks)
RB_EXPORT
const RBPath RBPathNull;

RB_EXPORT
RB_REFINED_FOR_SWIFT
void RBPathRetain(RBPath path) RB_SWIFT_NAME(RBPath.retain(self:));

RB_EXPORT
RB_REFINED_FOR_SWIFT
void RBPathRelease(RBPath path) RB_SWIFT_NAME(RBPath.release(self:));

// MARK: - Path Creation

RB_EXPORT
RBPath RBPathMakeWithCGPath(CGPathRef cgPath) RB_SWIFT_NAME(RBPath.init(cgPath:));

RB_EXPORT
RBPath RBPathMakeRect(CGRect rect, const CGAffineTransform * _Nullable transform) RB_SWIFT_NAME(RBPath.init(rect:transform:));

RB_EXPORT
RBPath RBPathMakeEllipse(CGRect rect, const CGAffineTransform * _Nullable transform) RB_SWIFT_NAME(RBPath.init(ellipseIn:transform:));

RB_EXPORT
RBPath RBPathMakeRoundedRect(CGRect rect, CGFloat cornerWidth, CGFloat cornerHeight, const CGAffineTransform * _Nullable transform) RB_SWIFT_NAME(RBPath.init(roundedRect:cornerWidth:cornerHeight:transform:));

RB_EXPORT
RBPath RBPathMakeUnevenRoundedRect(CGRect rect, CGFloat topLeftRadius, CGFloat bottomLeftRadius, CGFloat bottomRightRadius, CGFloat topRightRadius, const CGAffineTransform * _Nullable transform) RB_SWIFT_NAME(RBPath.init(roundedRect:topLeftRadius:bottomLeftRadius:bottomRightRadius:topRightRadius:transform:));

RB_EXTERN_C_END

RB_IMPLICIT_BRIDGING_DISABLED

RB_ASSUME_NONNULL_END
