//
//  AGWeakValue.h
//  AttributeGraph

#ifndef AGWeakValue_h
#define AGWeakValue_h

#include <AttributeGraph/AGBase.h>
#include <AttributeGraph/AGChangedValueFlags.h>

AG_ASSUME_NONNULL_BEGIN

typedef struct AGWeakValue {
    const void * _Nullable value;
    AGChangedValueFlags flags;
} AGWeakValue;

AG_ASSUME_NONNULL_END

#endif /* AGWeakValue_h */
