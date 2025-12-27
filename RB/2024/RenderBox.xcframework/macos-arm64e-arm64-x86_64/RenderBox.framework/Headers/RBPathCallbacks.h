//
//  RBPathCallbacks.h
//  RenderBox
//
//  Audited for 6.5.1
//  Status: Complete

#pragma once

#include <RenderBox/RBBase.h>
#include <RenderBox/RBPath.h>
#include <CoreGraphics/CoreGraphics.h>

RB_ASSUME_NONNULL_BEGIN

RB_EXTERN_C_BEGIN

/// Flags for path callbacks
typedef struct RBPathCallbacksFlags {
    uint8_t unknown0;
    uint8_t unknown1;
    bool isExtended;
    uint8_t padding[5];
} RBPathCallbacksFlags;

/// Callbacks structure for path operations
/// This allows different path storage types (CGPath, custom storage, etc.) to provide their own implementations
typedef struct RB_SWIFT_NAME(RBPath.Callbacks) RBPathCallbacks {
    RBPathCallbacksFlags flags;
    const void * _Nonnull (* _Nullable retain)(const void *object);
    void (* _Nullable release)(const void *object);
    bool (* _Nullable apply)(const void *object, void * info, RBPathApplyCallback _Nullable callback);
    bool (* _Nullable isEqual)(const void *object, const void *otherObject);
    bool (* _Nullable isEmpty)(const void *object);
    bool (* _Nullable isSingleElement)(const void *object);
    uint32_t (* _Nullable bezierOrder)(const void *object);
    CGRect (* _Nullable boundingRect)(const void *object);
    CGPathRef _Nullable (* _Nullable cgPath)(const void *object);
    const struct RBPathCallbacks * _Nullable (* _Nullable next)(const void *object);
} RBPathCallbacks;

/// Extended callbacks structure with additional extended callbacks argument
typedef struct RB_SWIFT_NAME(RBPath.CallbacksExtended) RBPathCallbacksExtended {
    RBPathCallbacksFlags flags;
    const void * _Nonnull (* _Nullable retain)(const void *object);
    void (* _Nullable release)(const void *object);
    bool (* _Nullable apply)(const void *object, void * info, RBPathApplyCallback _Nullable callback, const struct RBPathCallbacksExtended *extended);
    bool (* _Nullable isEqual)(const void *object, const void *otherObject, const struct RBPathCallbacksExtended *extended);
    bool (* _Nullable isEmpty)(const void *object, const struct RBPathCallbacksExtended *extended);
    bool (* _Nullable isSingleElement)(const void *object, const struct RBPathCallbacksExtended *extended);
    uint32_t (* _Nullable bezierOrder)(const void *object, const struct RBPathCallbacksExtended *extended);
    CGRect (* _Nullable boundingRect)(const void *object, const struct RBPathCallbacksExtended *extended);
    CGPathRef _Nullable (* _Nullable cgPath)(const void *object, const struct RBPathCallbacksExtended *extended);
    const struct RBPathCallbacksExtended * _Nullable (* _Nullable next)(const void *object, const struct RBPathCallbacksExtended *extended);
} RBPathCallbacksExtended;

/// Global callbacks for CGPath-backed paths
RB_EXPORT
const RBPathCallbacks RBPathCGPathCallbacks RB_SWIFT_NAME(RBPathCallbacks.cgPath);

RB_EXTERN_C_END

RB_ASSUME_NONNULL_END

