//
//  AGAttributeType.h
//  AttributeGraph

#ifndef AGAttributeType_h
#define AGAttributeType_h

#include <AttributeGraph/AGBase.h>
#include <AttributeGraph/AGAttributeTypeFlags.h>
#include <AttributeGraph/AGClosure.h>
#include <AttributeGraph/AGTypeID.h>

AG_ASSUME_NONNULL_BEGIN

typedef struct AGAttributeType AGAttributeType;

typedef struct AG_SWIFT_NAME(_AttributeVTable) AGAttributeVTable {
    unsigned long version;
    void (*_Nullable type_destroy)(AGAttributeType *);
    void (*_Nullable self_destroy)(const AGAttributeType *, void *);
    CFStringRef _Nullable (*_Nullable self_description)(const AGAttributeType *, const void *);
    CFStringRef _Nullable (*_Nullable value_description)(const AGAttributeType *, const void *);
    void (*_Nullable update_default)(const AGAttributeType *, void *);
} AGAttributeVTable;

typedef struct AG_SWIFT_NAME(_AttributeType) AGAttributeType {
    AGTypeID self_id;
    AGTypeID value_id;
    AGClosureStorage update;
    const AGAttributeVTable *vtable;
    AGAttributeTypeFlags flags;

    uint32_t internal_offset;
    const unsigned char *_Nullable value_layout;

    struct {
        AGTypeID type_id;
        const void *witness_table;
    } body_conformance;
} AGAttributeType;

AG_ASSUME_NONNULL_END

#endif /* AGAttributeType_h */
