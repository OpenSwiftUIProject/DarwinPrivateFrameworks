//
//  RBPath.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>

RB_ASSUME_NONNULL_BEGIN

RB_EXTERN_C_BEGIN

typedef struct RB_BRIDGED_TYPE(id) RBPathStorage * RBPathStorageRef RB_SWIFT_NAME(RBPath.Storage);

struct RBPathStorage;

typedef struct RBPath {
    RBPathStorageRef storage;
    void *callbacks;
} RBPath;

RB_EXPORT
RB_REFINED_FOR_SWIFT
void RBPathRetain(RBPath path) RB_SWIFT_NAME(RBPath.retain(self:));

RB_EXPORT
RB_REFINED_FOR_SWIFT
void RBPathRelease(RBPath path) RB_SWIFT_NAME(RBPath.release(self:));

RB_EXTERN_C_END

RB_ASSUME_NONNULL_END

