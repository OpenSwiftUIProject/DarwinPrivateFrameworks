//
//  AGCachedValueOptions.h
//  AttributeGraph

#ifndef AGCachedValueOptions_h
#define AGCachedValueOptions_h

#include <AttributeGraph/AGBase.h>

typedef AG_OPTIONS(uint32_t, AGCachedValueOptions) {
    AGCachedValueOptions_0 = 0,
    AGCachedValueOptions_1 = 1 << 0,
    AGCachedValueOptions_2 = 1 << 1,
    AGCachedValueOptions_4 = 1 << 2,
    AGCachedValueOptions_8 = 1 << 3,
    AGCachedValueOptions_16 = 1 << 4,
};

#endif /* AGCachedValueOptions_h */

