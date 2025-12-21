//
//  RBPathStorage.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>
#include <RenderBox/RBPath.h>
#include <CoreGraphics/CoreGraphics.h>

RB_ASSUME_NONNULL_BEGIN

RB_EXTERN_C_BEGIN

RB_EXPORT
RB_REFINED_FOR_SWIFT
void RBPathStorageInit(RBPathStorageRef dst, uint32_t capacity, RBPathStorageRef _Nullable source) RB_SWIFT_NAME(RBPathStorageRef.init(self:capacity:source:));

RB_EXPORT
RB_REFINED_FOR_SWIFT
void RBPathStorageDestroy(RBPathStorageRef storage) RB_SWIFT_NAME(RBPathStorageRef.destroy(self:));

RB_EXPORT
RB_REFINED_FOR_SWIFT
void RBPathStorageClear(RBPathStorageRef storage) RB_SWIFT_NAME(RBPathStorageRef.clear(self:));

RB_EXPORT
RB_REFINED_FOR_SWIFT
void RBPathStorageAppendPath(RBPathStorageRef, RBPath) RB_SWIFT_NAME(RBPathStorageRef.append(self:path:));

RB_EXPORT
RB_REFINED_FOR_SWIFT
bool RBPathStorageIsEmpty(RBPathStorageRef storage) RB_SWIFT_NAME(getter:RBPathStorageRef.isEmpty(self:));

RB_EXPORT
RB_REFINED_FOR_SWIFT
bool RBPathStorageEqualToStorage(RBPathStorageRef lhs, RBPathStorageRef rhs) RB_SWIFT_NAME(RBPathStorageRef.isEqualTo(self:_:));

RB_EXPORT
RB_REFINED_FOR_SWIFT
bool RBPathStorageIsSingleElement(RBPathStorageRef storage) RB_SWIFT_NAME(getter:RBPathStorageRef.isSingleElement(self:));

RB_EXPORT
RB_REFINED_FOR_SWIFT
uint32_t RBPathStorageGetBezierOrder(RBPathStorageRef storage) RB_SWIFT_NAME(getter:RBPathStorageRef.bezierOrder(self:));

RB_EXPORT
RB_REFINED_FOR_SWIFT
CGRect RBPathStorageGetBoundingRect(RBPathStorageRef storage) RB_SWIFT_NAME(getter:RBPathStorageRef.boundingRect(self:));

RB_EXPORT
RB_REFINED_FOR_SWIFT
CGPathRef RBPathStorageGetCGPath(RBPathStorageRef storage) RB_SWIFT_NAME(getter:RBPathStorageRef.cgPath(self:));

RB_EXTERN_C_END

RB_ASSUME_NONNULL_END
