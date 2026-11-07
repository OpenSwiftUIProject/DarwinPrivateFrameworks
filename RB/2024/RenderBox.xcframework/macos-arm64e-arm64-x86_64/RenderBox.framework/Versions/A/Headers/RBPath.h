//
//  RBPath.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>
#include <stddef.h>
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
    RBPathElementEllipse = 7,
    RBPathElementFixedRoundedRectCircular = 8,
    RBPathElementFixedRoundedRectContinuous = 9,
    RBPathElementUnevenRoundedRectCircular = 10,
    RBPathElementUnevenRoundedRectContinuous = 11,
    RBPathElementRelativeArc = 12,
    RBPathElementArc = 13,
    RBPathElementArcCounterclockwise = 14,
    RBPathElementArcTo = 15,
    RBPathElementEnd = 16,
    RBPathElementTransformed = 17,
    RBPathElementTrimmed = 18,
    RBPathElementStroked = 19,
    RBPathElementBoolean = 20,
    RBPathElementBooleanSeparator = 21,
    RBPathElementDilateGlyph = 22,
    RBPathElementOffset = 23,
    RBPathElementClipStroke = 24,

    RBPathElementInvalid = 25,
} RB_SWIFT_NAME(RBPath.Element);

RB_EXPORT
const uint8_t __RBPathElementArgumentCount[25];

/// Defines the shape of a rounded rectangle's corners.
typedef RB_ENUM(int32_t, RBPathRoundedCornerStyle) {
    /// Quarter-circle rounded rect corners.
    RBPathRoundedCornerStyleCircular = 0,
    /// Continuous curvature rounded rect corners.
    RBPathRoundedCornerStyleContinuous = 1,
} RB_SWIFT_NAME(RBPath.RoundedCornerStyle);

/// Callback type for path element enumeration
/// Returns true to continue enumeration, false to stop
typedef bool (*RBPathApplyCallback)(void * info, RBPathElement element, const CGFloat *points, const void * _Nullable userInfo);

/// Callback for mapped Core Graphics elements. Return false to stop callbacks.
typedef bool (*RBPathApplierCallback)(void *info, const CGPathElement *element);

typedef RB_ENUM(int32_t, RBPathLineElement) {
    RBPathLineElementMoveToPoint = 0,
    RBPathLineElementAddLineToPoint = 1,
    RBPathLineElementCloseSubpath = 2,
};

/// The point is unused for a close-subpath callback.
typedef bool (*RBPathLineApplyCallback)(void *info, RBPathLineElement element, const CGPoint *point);

typedef struct RBPathCallbacks RBPathCallbacks RB_SWIFT_NAME(RBPath.ApplyCallback);

typedef struct RBPathStorage * RBPathStorageRef RB_SWIFT_STRUCT RB_SWIFT_NAME(RBPath.Storage);

typedef struct RBPath {
    RBPathStorageRef storage;
    const RBPathCallbacks * callbacks;
} RBPath;

/// A primitive shape recognized by ``RBPathApplyShape``.
typedef RB_ENUM(int32_t, RBPathShapeType) {
    RBPathShapeTypeRect = 0,
    RBPathShapeTypeEllipse = 1,
    RBPathShapeTypeLine = 2,
    RBPathShapeTypeFixedRoundedRect = 3,
    RBPathShapeTypeUnevenRoundedRect = 4,
    RBPathShapeTypeNested = 5,
    RBPathShapeTypeStroked = 6,
    RBPathShapeTypeTrimmed = 7,
    RBPathShapeTypeOffset = 8,
};

typedef struct RBPathRectShape {
    CGAffineTransform transform;
    CGRect rect;
} RBPathRectShape;

typedef struct RBPathFixedRoundedRectShape {
    CGAffineTransform transform;
    CGRect rect;
    CGSize cornerSize;
    RBPathRoundedCornerStyle style;
} RBPathFixedRoundedRectShape;

typedef struct RBPathUnevenRoundedRectShape {
    CGAffineTransform transform;
    CGRect rect;
    CGFloat topLeftRadius;
    CGFloat topRightRadius;
    CGFloat bottomRightRadius;
    CGFloat bottomLeftRadius;
    RBPathRoundedCornerStyle style;
} RBPathUnevenRoundedRectShape;

typedef struct RBPathLineShape {
    CGPoint start;
    CGPoint end;
} RBPathLineShape;

typedef struct RBPathStrokeStyle {
    CGFloat lineWidth;
    int32_t lineCap;
    int32_t lineJoin;
    CGFloat miterLimit;
    CGFloat dashPhase;
    uint64_t dashCount;
    const CGFloat * _Nullable dash;
} RBPathStrokeStyle;

typedef struct RBPathStrokedShape {
    RBPath path;
    RBPathStrokeStyle style;
} RBPathStrokedShape;

typedef struct RBPathNestedShape {
    RBPath path;
    CGAffineTransform transform;
} RBPathNestedShape;

typedef struct RBPathTrimmedShape {
    RBPath path;
    CGFloat from;
    CGFloat to;
} RBPathTrimmedShape;

typedef union RBPathShape {
    RBPathRectShape rect;
    RBPathRectShape ellipse;
    RBPathLineShape line;
    RBPathFixedRoundedRectShape fixedRoundedRect;
    RBPathUnevenRoundedRectShape unevenRoundedRect;
    RBPathStrokedShape stroked;
    RBPathNestedShape nested;
    RBPathTrimmedShape trimmed;
} RBPathShape;

#if defined(__cplusplus) || (defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L)
static_assert(sizeof(RBPath) == 0x10);
static_assert(offsetof(RBPathUnevenRoundedRectShape, rect) == 0x30);
static_assert(offsetof(RBPathUnevenRoundedRectShape, topLeftRadius) == 0x50);
static_assert(offsetof(RBPathUnevenRoundedRectShape, style) == 0x70);
static_assert(sizeof(RBPathShape) == 0x78);
#endif

typedef void (*RBPathApplyShapeCallback)(void * info, RBPathShapeType type, const RBPathShape *shape);

/// Global empty path (storage = null, callbacks = &RBPathEmptyCallbacks)
RB_EXPORT
const RBPath RBPathEmpty RB_SWIFT_NAME(RBPath.empty);

/// Global null path (storage = 0x1, callbacks = &RBPathEmptyCallbacks)
RB_EXPORT
const RBPath RBPathNull RB_SWIFT_NAME(RBPath.null);

RB_EXPORT
RBPath RBPathRetain(RBPath path) RB_SWIFT_NAME(RBPath.retain(self:));

RB_EXPORT
void RBPathRelease(RBPath path) RB_SWIFT_NAME(RBPath.release(self:));

// MARK: - Path Creation

RB_EXPORT
RBPath RBPathMakeWithCGPath(CGPathRef _Nullable cgPath) RB_SWIFT_NAME(RBPath.init(cgPath:));

RB_EXPORT
RBPath RBPathMakeRect(CGRect rect, const CGAffineTransform * _Nullable transform) RB_SWIFT_NAME(RBPath.init(rect:transform:));

RB_EXPORT
RBPath RBPathMakeEllipse(CGRect rect, const CGAffineTransform * _Nullable transform) RB_SWIFT_NAME(RBPath.init(ellipseIn:transform:));

RB_EXPORT
RBPath RBPathMakeRoundedRect(CGRect rect, CGFloat cornerWidth, CGFloat cornerHeight, RBPathRoundedCornerStyle style, const CGAffineTransform * _Nullable transform) RB_SWIFT_NAME(RBPath.init(roundedRect:cornerWidth:cornerHeight:style:transform:));

RB_EXPORT
RBPath RBPathMakeUnevenRoundedRect(CGRect rect, CGFloat topLeftRadius, CGFloat topRightRadius, CGFloat bottomRightRadius, CGFloat bottomLeftRadius, RBPathRoundedCornerStyle style, const CGAffineTransform * _Nullable transform) RB_SWIFT_NAME(RBPath.init(roundedRect:topLeftRadius:topRightRadius:bottomRightRadius:bottomLeftRadius:style:transform:));

RB_EXPORT
RBPath RBPathCopyTransformedPath(RBPath path, const CGAffineTransform * _Nullable transform) RB_SWIFT_NAME(RBPath.copy(self:transform:));

RB_EXPORT
RBPath RBPathCopyStrokedPath(RBPath path, CGFloat lineWidth, int32_t lineCap, int32_t lineJoin, CGFloat miterLimit, CGFloat dashPhase, const CGFloat * _Nullable dash, size_t dashCount) RB_SWIFT_NAME(RBPath.stroked(self:lineWidth:lineCap:lineJoin:miterLimit:dashPhase:dash:dashCount:));

RB_EXPORT
RBPath RBPathCopyTrimmedPath(RBPath path, CGFloat from, CGFloat to) RB_SWIFT_NAME(RBPath.trimmed(self:from:to:));

// MARK: - Path Transformation


static RB_INLINE bool RBPathIsNull(RBPath path) RB_SWIFT_NAME(getter:RBPath.isNull(self:)) {
    return path.storage == RBPathNull.storage && path.callbacks == RBPathNull.callbacks;
}

// MARK: - Path Operation

RB_EXPORT
bool RBPathIsEmpty(RBPath path) RB_SWIFT_NAME(getter:RBPath.isEmpty(self:));

RB_EXPORT
bool RBPathIsSingleElement(RBPath path) RB_SWIFT_NAME(getter:RBPath.isSingleElement(self:));

RB_EXPORT
size_t RBPathGetBezierOrder(RBPath path) RB_SWIFT_NAME(getter:RBPath.bezierOrder(self:));

RB_EXPORT
bool RBPathApplyElements(RBPath path, void * info, _Nullable RBPathApplyCallback callback) RB_SWIFT_NAME(RBPath.apply(self:info:callback:));

RB_EXPORT
bool RBPathApplyShape(RBPath path, bool allowLine, void * info, RBPathApplyShapeCallback callback) RB_SWIFT_NAME(RBPath.applyShape(self:allowLine:info:callback:));

RB_EXPORT
bool RBPathEqualToPath(RBPath lhs, RBPath rhs) RB_SWIFT_NAME(RBPath.isEqual(self:to:));

// MARK: - CGPath Interoperability

RB_EXPORT
bool RBPathApply(RBPath path, const CGAffineTransform * _Nullable transform, void *info, RBPathApplierCallback callback) RB_SWIFT_NAME(RBPath.applyCGPathElements(self:transform:info:callback:));

RB_EXPORT
bool RBPathApplyLines(RBPath path, double tolerance, void *info, RBPathLineApplyCallback callback) RB_SWIFT_NAME(RBPath.applyLines(self:tolerance:info:callback:));

RB_EXPORT
double RBPathGetLength(RBPath path, double tolerance, const CGAffineTransform * _Nullable transform) RB_SWIFT_NAME(RBPath.length(self:tolerance:transform:));

RB_EXPORT
bool RBPathCanInterpolate(RBPath path, RBPath other) RB_SWIFT_NAME(RBPath.canInterpolate(self:to:));

RB_EXPORT
RBPath RBPathCopyInterpolatedPath(RBPath path, RBPath other, float fraction) RB_SWIFT_NAME(RBPath.interpolated(self:to:fraction:));

RB_EXPORT
CFDataRef RBPathCopyData(RBPath path) RB_SWIFT_NAME(getter:RBPath.data(self:));

RB_EXPORT
RBPath RBPathMakeWithData(CFDataRef data) RB_SWIFT_NAME(RBPath.init(data:));

RB_EXPORT
CFStringRef RBPathCopyDebugDescription(RBPath path) RB_SWIFT_NAME(getter:RBPath.debugDescription(self:));

RB_EXPORT
CGPathRef RBPathCopyCGPath(RBPath path) RB_SWIFT_NAME(getter:RBPath.cgPath(self:));

RB_EXPORT
CGRect RBPathGetBoundingRect(RBPath path) RB_SWIFT_NAME(getter:RBPath.boundingRect(self:));

// MARK: - Point Containment

RB_EXPORT
bool RBPathContainsPoint(RBPath path, CGPoint point, bool eoFill) RB_SWIFT_NAME(RBPath.contains(self:point:eoFill:));

RB_EXPORT
uint64_t RBPathContainsPoints(RBPath path, uint64_t count, const CGPoint *points, bool eoFill, const CGAffineTransform * _Nullable transform) RB_SWIFT_NAME(RBPath.containsPoints(self:count:points:eoFill:transform:));

RB_EXTERN_C_END

RB_ASSUME_NONNULL_END
