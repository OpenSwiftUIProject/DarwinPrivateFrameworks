//
//  RBPathStorage.h
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

RB_EXPORT
void RBPathStorageInit(RBPathStorageRef dst, uint32_t capacity, RBPathStorageRef _Nullable source) RB_SWIFT_NAME(RBPathStorageRef.initialize(self:capacity:source:));

RB_EXPORT
void RBPathStorageDestroy(RBPathStorageRef storage) RB_SWIFT_NAME(RBPathStorageRef.destroy(self:));

RB_EXPORT
void RBPathStorageClear(RBPathStorageRef storage) RB_SWIFT_NAME(RBPathStorageRef.clear(self:));

RB_EXPORT
bool RBPathStorageAppendElement(RBPathStorageRef storage, RBPathElement element, CGFloat const * points, const void * _Nullable userInfo) RB_SWIFT_NAME(RBPathStorageRef.append(self:element:points:userInfo:));

RB_EXPORT
bool RBPathStorageAppendPath(RBPathStorageRef, RBPath) RB_SWIFT_NAME(RBPathStorageRef.append(self:path:));

RB_EXPORT
bool RBPathStorageApplyElements(RBPathStorageRef, void *info, RBPathApplyCallback _Nullable callback) RB_SWIFT_NAME(RBPathStorageRef.apply(self:info:callback:));

RB_EXPORT
bool RBPathStorageIsEmpty(RBPathStorageRef storage) RB_SWIFT_NAME(getter:RBPathStorageRef.isEmpty(self:));

RB_EXPORT
bool RBPathStorageEqualToStorage(RBPathStorageRef lhs, RBPathStorageRef rhs) RB_SWIFT_NAME(RBPathStorageRef.isEqual(self:to:));

RB_EXPORT
bool RBPathStorageIsSingleElement(RBPathStorageRef storage) RB_SWIFT_NAME(getter:RBPathStorageRef.isSingleElement(self:));

RB_EXPORT
uint32_t RBPathStorageGetBezierOrder(RBPathStorageRef storage) RB_SWIFT_NAME(getter:RBPathStorageRef.bezierOrder(self:));

RB_EXPORT
CGRect RBPathStorageGetBoundingRect(RBPathStorageRef storage) RB_SWIFT_NAME(getter:RBPathStorageRef.boundingRect(self:));

RB_EXPORT
CF_RETURNS_NOT_RETAINED
__nullable CGPathRef RBPathStorageGetCGPath(RBPathStorageRef storage) RB_SWIFT_NAME(getter:RBPathStorageRef.cgPath(self:));

RB_EXTERN_C_END

RB_ASSUME_NONNULL_END
