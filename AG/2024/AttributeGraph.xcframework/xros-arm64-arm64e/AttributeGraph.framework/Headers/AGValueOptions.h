//
//  AGValueOptions.h
//  AttributeGraph

#ifndef AGValueOptions_h
#define AGValueOptions_h

#include <AttributeGraph/AGBase.h>

typedef AG_OPTIONS(uint32_t, AGValueOptions) {
    AGValueOptionsNone = 0,
    AGValueOptionsInputOptionsUnprefetched = 1 << 0,
    AGValueOptionsInputOptionsSyncMainRef = 1 << 1,
    AGValueOptionsInputOptionsMask = 0x03,

    AGValueOptionsIncrementGraphVersion = 1 << 2, // AsTopLevelOutput
};

#endif /* AGValueOptions_h */
