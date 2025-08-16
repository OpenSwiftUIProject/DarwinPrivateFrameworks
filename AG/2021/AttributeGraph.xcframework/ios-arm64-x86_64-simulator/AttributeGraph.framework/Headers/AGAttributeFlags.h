//
//  AGAttributeFlags.h
//  AttributeGraph
//
//  Audited for RELEASE_2021
//  Status: Complete

#ifndef AGAttributeFlags_h
#define AGAttributeFlags_h

#include <AttributeGraph/AGBase.h>
#include <AttributeGraph/AGGraph.h>

typedef AG_OPTIONS(uint8_t, AGAttributeFlags) {
    AGAttributeFlagsNone = 0,
    AGAttributeFlagsAll = 0xFF,
} AG_SWIFT_NAME(AGAttribute.Flags);

#endif /* AGAttributeFlags_h */
