//
//  AGValue.h
//  AttributeGraph

#ifndef AGValue_h
#define AGValue_h

#include <AttributeGraph/AGBase.h>
#include <AttributeGraph/AGChangedValueFlags.h>

AG_ASSUME_NONNULL_BEGIN

typedef struct AGValue {
    const void *value;
    AGChangedValueFlags flags;
} AGValue;

AG_ASSUME_NONNULL_END

#endif /* AGValue_h */
