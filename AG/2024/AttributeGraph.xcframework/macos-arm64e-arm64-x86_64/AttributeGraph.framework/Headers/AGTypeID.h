//
//  AGTypeID.h
//  AttributeGraph

#ifndef AGTypeID_h
#define AGTypeID_h

#include "AGBase.h"
#include "AGVersion.h"

AG_ASSUME_NONNULL_BEGIN

typedef struct AG_SWIFT_NAME(_Metadata) AGSwiftMetadata {
} AGSwiftMetadata;

typedef const AGSwiftMetadata *AGTypeID AG_SWIFT_STRUCT AG_SWIFT_NAME(Metadata);

typedef AG_CLOSED_ENUM(uint32_t, AGTypeKind) {
    AGTypeKindNone,
    AGTypeKindClass,
    AGTypeKindStruct,
    AGTypeKindEnum,
    AGTypeKindOptional,
    AGTypeKindTuple,
    AGTypeKindFunction,
    AGTypeKindExistential,
    AGTypeKindMetatype,
} AG_SWIFT_NAME(Metadata.Kind);

AG_EXTERN_C_BEGIN

AG_EXPORT
AG_REFINED_FOR_SWIFT
AGTypeKind AGTypeGetKind(AGTypeID typeID) AG_SWIFT_NAME(getter:Metadata.kind(self:));

#if ATTRIBUTEGRAPH_RELEASE >= 2024

AG_EXPORT
AG_REFINED_FOR_SWIFT
void const* _Nullable AGTypeGetSignature(AGTypeID typeID) AG_SWIFT_NAME(getter:Metadata.signature(self:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
void const* _Nullable AGTypeGetDescriptor(AGTypeID typeID) AG_SWIFT_NAME(getter:Metadata.descriptor(self:));

#endif /* ATTRIBUTEGRAPH */

AG_EXPORT
AG_REFINED_FOR_SWIFT
CFStringRef AGTypeDescription(AGTypeID type);

AG_EXPORT
AG_REFINED_FOR_SWIFT
void const* _Nullable AGTypeNominalDescriptor(AGTypeID typeID) AG_SWIFT_NAME(getter:Metadata.nominalDescriptor(self:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
char const* _Nullable AGTypeNominalDescriptorName(AGTypeID typeID) AG_SWIFT_NAME(getter:Metadata.nominalDescriptorName(self:));

AG_EXTERN_C_END

AG_ASSUME_NONNULL_END

#endif /* AGTypeID_h */
