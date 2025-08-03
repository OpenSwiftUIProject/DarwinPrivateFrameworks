//
//  AGComparison.h
//  AttributeGraph
//
//  Audited for 6.5.1
//  Status: Complete

#ifndef AGComparison_h
#define AGComparison_h

#include <AttributeGraph/AGBase.h>
#include <AttributeGraph/AGTypeID.h>

AG_ASSUME_NONNULL_BEGIN

AG_IMPLICIT_BRIDGING_ENABLED

AG_EXTERN_C_BEGIN

typedef struct AGFieldRange {
    size_t offset;
    size_t size;
} AGFieldRange AG_SWIFT_STRUCT AG_SWIFT_NAME(FieldRange);

typedef const void *AGComparisonState AG_SWIFT_STRUCT AG_SWIFT_NAME(ComparisonState);

AG_EXPORT
AG_REFINED_FOR_SWIFT
const void *AGComparisonStateGetDestination(AGComparisonState state) AG_SWIFT_NAME(getter:AGComparisonState.destination(self:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
const void *AGComparisonStateGetSource(AGComparisonState state) AG_SWIFT_NAME(getter:AGComparisonState.source(self:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
AGFieldRange AGComparisonStateGetFieldRange(AGComparisonState state) AG_SWIFT_NAME(getter:AGComparisonState.fieldRange(self:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
AGTypeID AGComparisonStateGetFieldType(AGComparisonState state) AG_SWIFT_NAME(getter:AGComparisonState.fieldType(self:));

typedef AG_ENUM(uint8_t, AGComparisonMode) {
    AGComparisonModeBitwise = 0,
    AGComparisonModeIndirect = 1,
    AGComparisonModeEquatableUnlessPOD = 2,
    AGComparisonModeEquatableAlways = 3,
} AG_SWIFT_NAME(ComparisonMode);

typedef AG_OPTIONS(uint32_t, AGComparisonOptions) {
    AGComparisonOptionsComparisonModeBitwise = 0,
    AGComparisonOptionsComparisonModeIndirect = 1,
    AGComparisonOptionsComparisonModeEquatableUnlessPOD = 2,
    AGComparisonOptionsComparisonModeEquatableAlways = 3,
    AGComparisonOptionsComparisonModeMask = 0xff,

    AGComparisonOptionsCopyOnWrite = 1 << 8,
    AGComparisonOptionsFetchLayoutsSynchronously = 1 << 9,
    AGComparisonOptionsReportFailures = 1ul << 31, // -1 signed int
} AG_SWIFT_NAME(ComparisonOptions);

AG_EXPORT
AG_REFINED_FOR_SWIFT
bool AGCompareValues(const void *lhs,
                     const void *rhs,
                     AGTypeID type_id,
                     AGComparisonOptions options);

AG_EXPORT
AG_REFINED_FOR_SWIFT
const unsigned char *_Nullable AGPrefetchCompareValues(AGTypeID type_id,
                                                       AGComparisonOptions options,
                                                       uint32_t priority);

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGOverrideComparisonForTypeDescriptor(void *descriptor, AGComparisonMode mode);

AG_EXTERN_C_END

AG_IMPLICIT_BRIDGING_DISABLED

AG_ASSUME_NONNULL_END

#endif /* AGComparison_h */
