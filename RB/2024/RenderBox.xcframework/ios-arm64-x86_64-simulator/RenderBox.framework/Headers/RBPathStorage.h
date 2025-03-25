//
//  RBPathStorage.h
//  RenderBox

#ifndef RBPathStorage_h
#define RBPathStorage_h

#include "RBBase.h"
#include "RBPath.h"

#if RB_TARGET_OS_DARWIN
#include <CoreGraphics/CoreGraphics.h>
#endif

RB_ASSUME_NONNULL_BEGIN

RB_EXTERN_C_BEGIN

RB_EXPORT
RB_REFINED_FOR_SWIFT
void RBPathStorageInit(RBPathStorage* dst, uint32_t capacity, RBPathStorage* _Nullable source);

RB_EXPORT
RB_REFINED_FOR_SWIFT
void RBPathStorageDestroy(RBPathStorage storage) RB_SWIFT_NAME(RBPathStorage.destroy(self:));

RB_EXPORT
RB_REFINED_FOR_SWIFT
void RBPathStorageClear(RBPathStorage storage) RB_SWIFT_NAME(RBPathStorage.clear(self:));

//RB_EXPORT
//RB_REFINED_FOR_SWIFT
//void RBPathStorageAppendPath(RBPathStorage, RBPath);

RB_EXPORT
RB_REFINED_FOR_SWIFT
bool RBPathStorageIsEmpty(RBPathStorage storage) RB_SWIFT_NAME(getter:RBPathStorage.isEmpty(self:));

RB_EXPORT
RB_REFINED_FOR_SWIFT
bool RBPathStorageEqualToStorage(RBPathStorage lhs, RBPathStorage rhs) RB_SWIFT_NAME(RBPathStorage.isEqualTo(self:_:));

RB_EXPORT
RB_REFINED_FOR_SWIFT
bool RBPathStorageIsSingleElement(RBPathStorage storage) RB_SWIFT_NAME(getter:RBPathStorage.isSingleElement(self:));

RB_EXPORT
RB_REFINED_FOR_SWIFT
uint32_t RBPathStorageGetBezierOrder(RBPathStorage storage) RB_SWIFT_NAME(getter:RBPathStorage.bezierOrder(self:));

#if RB_TARGET_OS_DARWIN
RB_EXPORT
RB_REFINED_FOR_SWIFT
CGRect RBPathStorageGetBoundingRect(RBPathStorage storage) RB_SWIFT_NAME(getter:RBPathStorage.boundingRect(self:));

RB_EXPORT
RB_REFINED_FOR_SWIFT
CGPathRef RBPathStorageGetCGPath(RBPathStorage storage) RB_SWIFT_NAME(getter:RBPathStorage.cgPath(self:));
#endif

RB_EXTERN_C_END

RB_ASSUME_NONNULL_END

#endif /* RBPathStorage_h */
