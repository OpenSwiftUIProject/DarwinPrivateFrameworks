//
//  AGTypeID.h
//  AttributeGraph

#ifndef AGTypeID_h
#define AGTypeID_h

#include "AGBase.h"
#include "AGVersion.h"

AG_ASSUME_NONNULL_BEGIN

typedef const struct AGSwiftMetadata *AGTypeID AG_SWIFT_STRUCT AG_SWIFT_NAME(Metadata);

#if ATTRIBUTEGRAPH_RELEASE >= ATTRIBUTEGRAPH_RELEASE_2024

typedef struct AG_SWIFT_NAME(TypeSignature) AGTypeSignature {
    uint32_t bytes[5];
} AGTypeSignature;

#endif /* ATTRIBUTEGRAPH_RELEASE */

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

typedef AG_OPTIONS(uint32_t, AGTypeApplyOptions){
    AGTypeApplyOptionsEnumerateStructFields = 0,
    AGTypeApplyOptionsEnumerateClassFields = 1 << 0,
    AGTypeApplyOptionsContinueAfterUnknownField = 1 << 1,
    AGTypeApplyOptionsEnumerateEnumCases = 1 << 2,
};

AG_EXTERN_C_BEGIN

AG_EXPORT
AG_REFINED_FOR_SWIFT
AGTypeKind AGTypeGetKind(AGTypeID typeID) AG_SWIFT_NAME(getter:Metadata.kind(self:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGTypeApplyFields(const void *type, const void *block, void *context);

AG_EXPORT
AG_REFINED_FOR_SWIFT
bool AGTypeApplyFields2(const void *type, AGTypeApplyOptions options, const void *block, void *context);

AG_EXPORT
AG_REFINED_FOR_SWIFT
uint32_t AGTypeGetEnumTag(AGTypeID typeID, const void *value) AG_SWIFT_NAME(Metadata.enumTag(self:_:));

#if ATTRIBUTEGRAPH_RELEASE >= ATTRIBUTEGRAPH_RELEASE_2024

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGTypeProjectEnumData(AGTypeID typeID, void *value) AG_SWIFT_NAME(Metadata.projectEnumData(self:_:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGTypeInjectEnumTag(AGTypeID typeID, uint32_t tag, void *value) AG_SWIFT_NAME(Metadata.injectEnumTag(self:tag:_:));

#endif /* ATTRIBUTEGRAPH_RELEASE */

// TODO
AG_EXPORT
AG_REFINED_FOR_SWIFT
bool AGTypeApplyEnumData();

AG_EXPORT
AG_REFINED_FOR_SWIFT
bool AGTypeApplyMutableEnumData();

AG_EXPORT
AG_REFINED_FOR_SWIFT
CFStringRef AGTypeDescription(AGTypeID type);

#if ATTRIBUTEGRAPH_RELEASE >= ATTRIBUTEGRAPH_RELEASE_2024

AG_EXPORT
AG_REFINED_FOR_SWIFT
AGTypeSignature const AGTypeGetSignature(AGTypeID typeID) AG_SWIFT_NAME(getter:Metadata.signature(self:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
void const* _Nullable AGTypeGetDescriptor(AGTypeID typeID) AG_SWIFT_NAME(getter:Metadata.descriptor(self:));

#endif /* ATTRIBUTEGRAPH_RELEASE */

AG_EXPORT
AG_REFINED_FOR_SWIFT
void const* _Nullable AGTypeNominalDescriptor(AGTypeID typeID) AG_SWIFT_NAME(getter:Metadata.nominalDescriptor(self:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
char const* _Nullable AGTypeNominalDescriptorName(AGTypeID typeID) AG_SWIFT_NAME(getter:Metadata.nominalDescriptorName(self:));

AG_EXTERN_C_END

AG_ASSUME_NONNULL_END

#endif /* AGTypeID_h */
