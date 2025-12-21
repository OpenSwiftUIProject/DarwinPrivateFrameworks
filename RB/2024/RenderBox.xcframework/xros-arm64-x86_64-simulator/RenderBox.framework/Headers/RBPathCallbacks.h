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

/// Callbacks structure for path operations
/// This allows different path storage types (CGPath, custom storage, etc.) to provide their own implementations
typedef struct RB_SWIFT_NAME(RBPath.Callbacks) RBPathCallbacks {
    void (* _Nullable unknown1)(const void * object); // 0x00
    const void * _Nonnull (* _Nullable retain)(const void *object); // 0x08
    void (* _Nullable release)(const void *object); // 0x10
    bool (* _Nullable apply)(const void *object, void * info, RBPathApplyCallback _Nullable callback); // 0x18
    bool (* _Nullable isEqual)(const void *object, const void *otherObject); // 0x20
    bool (* _Nullable isEmpty)(const void *object); // 0x28
    bool (* _Nullable isSingleElement)(const void *object); // 0x30
    uint32_t (* _Nullable bezierOrder)(const void *object); // 0x38
    CGRect (* _Nullable boundingRect)(const void *object); // 0x40
    CGPathRef _Nullable (* _Nullable cgPath)(const void *object); // 0x48
    void (* _Nullable unknown2)(const void *); // 0x50
} RBPathCallbacks;

/// Global callbacks for CGPath-backed paths
RB_EXPORT
const RBPathCallbacks RBPathCGPathCallbacks RB_SWIFT_NAME(RBPathCallbacks.cgPath);

RB_EXTERN_C_END

RB_ASSUME_NONNULL_END

