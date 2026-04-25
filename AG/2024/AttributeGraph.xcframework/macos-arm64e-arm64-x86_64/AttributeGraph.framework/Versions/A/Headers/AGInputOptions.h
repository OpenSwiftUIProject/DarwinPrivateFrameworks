//
//  AGInputOptions.h
//  AttributeGraph

#ifndef AGInputOptions_h
#define AGInputOptions_h

#include <AttributeGraph/AGBase.h>

typedef AG_OPTIONS(uint32_t, AGInputOptions) {
    AGInputOptionsNone = 0,
    AGInputOptionsUnprefetched = 1 << 0,
    AGInputOptionsSyncMainRef = 1 << 1,
};

#endif /* AGInputOptions_h */
