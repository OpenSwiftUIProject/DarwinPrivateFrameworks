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

/// Defines the shape of a rounded rectangle's corners.
typedef RB_ENUM(int32_t, RBRoundedCornerStyle) {
    /// Quarter-circle rounded rect corners.
    RBRoundedCornerStyleCircular = 0,
    /// Continuous curvature rounded rect corners.
    RBRoundedCornerStyleContinuous = 1,
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

/// Callback function pointer types for RBPathCallbacks
typedef void (* _Nullable RBPathRetainCallback)(RBPathRef path);
typedef void (* _Nullable RBPathReleaseCallback)(RBPathRef path);
typedef bool (* _Nullable RBPathApplyFunction)(RBPathRef path, void * _Nullable info, RBPathApplyCallback _Nullable callback);
typedef bool (* _Nullable RBPathIsEqualCallback)(RBPathRef path, RBPathRef otherPath);
typedef bool (* _Nullable RBPathIsEmptyCallback)(RBPathRef path);
typedef bool (* _Nullable RBPathIsSingleRectCallback)(RBPathRef path);
typedef uint32_t (* _Nullable RBPathBezierOrderCallback)(RBPathRef path);
typedef CGRect (* _Nullable RBPathBoundingBoxCallback)(RBPathRef path);
typedef CGPathRef _Nullable (* _Nullable RBPathGetCGPathCallback)(RBPathRef path);

/// Callbacks structure for path operations
/// This allows different path storage types (CGPath, custom storage, etc.) to provide their own implementations
typedef struct RBPathCallbacks {
    void * _Nullable reserved;              // 0x00: Reserved for future use
    RBPathRetainCallback retain;            // 0x08: Retain callback
    RBPathReleaseCallback release;          // 0x10: Release callback
    RBPathApplyFunction apply;              // 0x18: Enumerate path elements
    RBPathIsEqualCallback isEqual;          // 0x20: Compare two paths
    RBPathIsEmptyCallback isEmpty;          // 0x28: Check if path is empty
    RBPathIsSingleRectCallback isSingleRect; // 0x30: Check if path is a single rectangle
    RBPathBezierOrderCallback bezierOrder;  // 0x38: Get bezier order (1=linear, 2=quad, 3=cubic)
    RBPathBoundingBoxCallback boundingBox;  // 0x40: Get bounding box
    RBPathGetCGPathCallback cgPath;         // 0x48: Get CGPath representation
    void * _Nullable reserved2;             // 0x50: Reserved for future use
} RBPathCallbacks;

typedef struct RBPath {
    RBPathStorageRef storage;
    RBPathCallbacksRef callbacks;
} RBPath;

/// Global empty path callbacks (all null)
RB_EXPORT
const RBPathCallbacks RBPathEmptyCallbacks;

/// Global callbacks for CGPath-backed paths
RB_EXPORT
const RBPathCallbacks RBPathCGPathCallbacks;

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
RBPath RBPathMakeRoundedRect(CGRect rect, CGFloat cornerWidth, CGFloat cornerHeight, RBRoundedCornerStyle style, const CGAffineTransform * _Nullable transform) RB_SWIFT_NAME(RBPath.init(roundedRect:cornerWidth:cornerHeight:style:transform:));

RB_EXPORT
RBPath RBPathMakeUnevenRoundedRect(CGRect rect, CGFloat topLeftRadius, CGFloat bottomLeftRadius, CGFloat bottomRightRadius, CGFloat topRightRadius, RBRoundedCornerStyle style, const CGAffineTransform * _Nullable transform) RB_SWIFT_NAME(RBPath.init(roundedRect:topLeftRadius:bottomLeftRadius:bottomRightRadius:topRightRadius:style:transform:));

RB_EXPORT
CGPathRef RBPathCopyCGPath(RBPath path) RB_SWIFT_NAME(getter:RBPath.cgPath(self:));

RB_EXPORT
bool RBPathContainsPoint(RBPath path, CGPoint point, bool eoFill) RB_SWIFT_NAME(RBPath.contains(self:point:eoFill:));

RB_EXPORT
bool RBPathContainsPoints(RBPath path, uint64_t count, const CGPoint *points, bool eoFill, const CGAffineTransform * _Nullable transform) RB_SWIFT_NAME(RBPath.containsPoints(self:count:points:eoFill:transform:));

RB_EXTERN_C_END

RB_IMPLICIT_BRIDGING_DISABLED

RB_ASSUME_NONNULL_END
