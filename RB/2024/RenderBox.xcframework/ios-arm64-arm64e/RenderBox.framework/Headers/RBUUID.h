//
//  RBUUID.h
//  RenderBox

#ifndef RBUUID_h
#define RBUUID_h

#include "RBBase.h"
#include <Foundation/Foundation.h>

typedef struct RBUUID {
    uint8_t bytes[16];
} RBUUID;

RB_EXTERN_C_BEGIN

RB_EXPORT
RB_REFINED_FOR_SWIFT
RBUUID RBUUIDInitFromNSUUID(NSUUID *uuid) RB_SWIFT_NAME(RBUUID.init(uuid:));

RB_EXPORT
RB_REFINED_FOR_SWIFT
RBUUID RBUUIDInitFromHash(uint64_t words0, uint64_t words1, uint32_t words2) RB_SWIFT_NAME(RBUUID.init(_:_:_:));

RB_EXTERN_C_END

#endif /* RBUUID_h */
