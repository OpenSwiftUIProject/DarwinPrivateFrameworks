//
//  AGTupleType.h
//  AttributeGraph

#ifndef AGTupleType_h
#define AGTupleType_h

#include "AGBase.h"
#include "AGTypeID.h"

AG_ASSUME_NONNULL_BEGIN

AG_IMPLICIT_BRIDGING_ENABLED

typedef const AGSwiftMetadata *AGTupleType AG_SWIFT_STRUCT AG_SWIFT_NAME(TupleType);

typedef AG_CLOSED_ENUM(uint32_t, AGTupleCopyOptions) {
    AGTupleCopyOptionsAssignCopy = 0,
    AGTupleCopyOptionsInitCopy = 1,
    AGTupleCopyOptionsAssignTake = 2,
    AGTupleCopyOptionsInitTake = 3
} AG_SWIFT_NAME(TupleType.CopyOptions);

typedef struct AG_SWIFT_NAME(UnsafeTuple) AGUnsafeTuple {
    AGTupleType type;
    const void *value;
} AGUnsafeTuple;

typedef struct AG_SWIFT_NAME(UnsafeMutableTuple) AGUnsafeMutableTuple {
    AGTupleType type;
    void *value;
} AGUnsafeMutableTuple;

AG_EXTERN_C_BEGIN

AG_EXPORT
AG_REFINED_FOR_SWIFT
AGTupleType AGNewTupleType(size_t count, const AGTypeID _Nonnull * _Nonnull elements) AG_SWIFT_NAME(TupleType.init(count:elements:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
size_t AGTupleCount(AGTupleType tuple_type) AG_SWIFT_NAME(getter:TupleType.count(self:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
size_t AGTupleSize(AGTupleType tuple_type) AG_SWIFT_NAME(getter:TupleType.size(self:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
AGTypeID AGTupleElementType(AGTupleType tuple_type, size_t index) AG_SWIFT_NAME(TupleType.elementType(self:at:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
size_t AGTupleElementSize(AGTupleType tuple_type, size_t index) AG_SWIFT_NAME(TupleType.elementSize(self:at:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
size_t AGTupleElementOffset(AGTupleType tuple_type, size_t index) AG_SWIFT_NAME(TupleType.elementOffset(self:at:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
size_t AGTupleElementOffsetChecked(AGTupleType tuple_type, size_t index, AGTypeID check_type) AG_SWIFT_NAME(TupleType.elementOffset(self:at:type:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
void *AGTupleSetElement(AGTupleType tuple_type, void* tuple_value, size_t index, const void *element_value, AGTypeID check_type, AGTupleCopyOptions mode);

AG_EXPORT
AG_REFINED_FOR_SWIFT
void *AGTupleGetElement(AGTupleType tuple_type, void* tuple_value, size_t index, void *element_value, AGTypeID check_type, AGTupleCopyOptions mode);

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGTupleDestroy(AGTupleType tuple_type, void *buffer) AG_SWIFT_NAME(TupleType.destroy(self:_:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGTupleDestroyElement(AGTupleType tuple_type, void *buffer, size_t index) AG_SWIFT_NAME(TupleType.destroy(self:_:at:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGTupleWithBuffer(AGTupleType tuple_type, size_t count, const void (* function)(const AGUnsafeMutableTuple mutableTuple, const void * context AG_SWIFT_CONTEXT) AG_SWIFT_CC(swift), const void *context);

AG_EXTERN_C_END

AG_IMPLICIT_BRIDGING_DISABLED

AG_ASSUME_NONNULL_END

#endif /* AGTupleType_h */
