//
//  AGComparison.h
//  AttributeGraph

#ifndef AGComparison_h
#define AGComparison_h

#include "AGBase.h"
#include "AGTypeID.h"

AG_ASSUME_NONNULL_BEGIN

AG_EXTERN_C_BEGIN

typedef struct AGFieldRange {
    size_t offset;
    size_t size;
} AGFieldRange;

typedef struct AGComparisonStateStorage *AGComparisonState;

AG_EXPORT
AG_REFINED_FOR_SWIFT
const void *AGComparisonStateGetDestination(AGComparisonState state);

AG_EXPORT
AG_REFINED_FOR_SWIFT
const void *AGComparisonStateGetSource(AGComparisonState state);

AG_EXPORT
AG_REFINED_FOR_SWIFT
AGFieldRange AGComparisonStateGetFieldRange(AGComparisonState state);

AG_EXPORT
AG_REFINED_FOR_SWIFT
AGTypeID AGComparisonStateGetFieldType(AGComparisonState state);

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

AG_ASSUME_NONNULL_END

#endif /* AGComparison_h */
