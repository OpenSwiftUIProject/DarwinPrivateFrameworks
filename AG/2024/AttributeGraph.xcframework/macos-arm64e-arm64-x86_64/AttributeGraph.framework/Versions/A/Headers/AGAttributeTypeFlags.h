//
//  AGAttributeTypeFlags.h
//  AttributeGraph

#ifndef AGAttributeTypeFlags_h
#define AGAttributeTypeFlags_h

#include <AttributeGraph/AGBase.h>

typedef AG_OPTIONS(uint32_t, AGAttributeTypeFlags) {
    AGAttributeTypeFlagsComparisonModeBitwise = 0,
    AGAttributeTypeFlagsComparisonModeIndirect = 1,
    AGAttributeTypeFlagsComparisonModeEquatableUnlessPOD = 2,
    AGAttributeTypeFlagsComparisonModeEquatableAlways = 3,
    AGAttributeTypeFlagsComparisonModeMask = 0x03,

    AGAttributeTypeFlagsHasDestroySelf = 1 << 2,
    AGAttributeTypeFlagsMainThread = 1 << 3,
    AGAttributeTypeFlagsExternal = 1 << 4,
    AGAttributeTypeFlagsAsyncThread = 1 << 5,
} AG_SWIFT_NAME(AGAttributeType.Flags);

#endif /* AGAttributeTypeFlags_h */

