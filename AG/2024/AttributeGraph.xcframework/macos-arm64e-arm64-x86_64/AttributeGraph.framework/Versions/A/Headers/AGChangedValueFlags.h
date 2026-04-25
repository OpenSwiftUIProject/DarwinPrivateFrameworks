//
//  AGChangedValueFlags.h
//  AttributeGraph

#ifndef AGChangedValueFlags_h
#define AGChangedValueFlags_h

#include <AttributeGraph/AGBase.h>

typedef AG_OPTIONS(uint32_t, AGChangedValueFlags) {
    AGChangedValueFlagsChanged = 1 << 0,
    AGChangedValueFlagsRequiresMainThread = 1 << 1,
};

#endif /* AGChangedValueFlags_h */
