//
//  RBPathCallbacks.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>
#include <RenderBox/RBPath.h>
#include <CoreGraphics/CoreGraphics.h>

RB_ASSUME_NONNULL_BEGIN

RB_EXTERN_C_BEGIN

/// Callbacks structure for path operations
/// This allows different path storage types (CGPath, custom storage, etc.) to provide their own implementations
typedef struct RB_SWIFT_NAME(RBPath.Callbacks) RBPathCallbacks {
    void * _Nullable reserved;              // 0x00: Reserved for future use

    void (* _Nullable retain)(const RBPath *path);           // 0x08
    void (* _Nullable release)(const RBPath *path);          // 0x10
    bool (* _Nullable apply)(const RBPath *path, void * _Nullable info, RBPathApplyCallback _Nullable callback); // 0x18
    bool (* _Nullable isEqual)(const RBPath *path, const RBPath *otherPath); // 0x20
    bool (* _Nullable isEmpty)(const RBPath *path);          // 0x28
    bool (* _Nullable isSingleRect)(const RBPath *path);     // 0x30
    uint32_t (* _Nullable bezierOrder)(const RBPath *path);  // 0x38
    CGRect (* _Nullable boundingBox)(const RBPath *path);    // 0x40
    CGPathRef _Nullable (* _Nullable cgPath)(const RBPath *path); // 0x48
    void * _Nullable reserved2;             // 0x50
} RBPathCallbacks;

/// Global empty path callbacks (all null)
RB_EXPORT
const RBPathCallbacks RBPathEmptyCallbacks RB_SWIFT_NAME(RBPathCallbacks.empty);

/// Global callbacks for CGPath-backed paths
RB_EXPORT
const RBPathCallbacks RBPathCGPathCallbacks RB_SWIFT_NAME(RBPathCallbacks.cgPath);

RB_EXTERN_C_END

RB_ASSUME_NONNULL_END

