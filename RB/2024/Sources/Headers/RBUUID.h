//
//  RBUUID.hpp
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>

#if RB_TARGET_OS_DARWIN && __OBJC__
#include <Foundation/Foundation.h>
#endif

typedef struct RBUUID {
    uint8_t bytes[16];
} RBUUID;

RB_EXTERN_C_BEGIN

#if RB_TARGET_OS_DARWIN && __OBJC__
RB_EXPORT
RB_REFINED_FOR_SWIFT
RBUUID RBUUIDInitFromNSUUID(NSUUID *uuid) RB_SWIFT_NAME(RBUUID.init(uuid:));
#endif

RB_EXPORT
RB_REFINED_FOR_SWIFT
RBUUID RBUUIDInitFromHash(uint64_t words0, uint64_t words1, uint32_t words2) RB_SWIFT_NAME(RBUUID.init(_:_:_:));

RB_EXTERN_C_END

