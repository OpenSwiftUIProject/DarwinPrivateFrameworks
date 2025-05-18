//
//  AGChangedValueFlags.h
//
//
//  Created by Kyle on 2024/2/21.
//

#ifndef AGChangedValueFlags_h
#define AGChangedValueFlags_h

#include "AGBase.h"

typedef AG_OPTIONS(uint32_t, AGChangedValueFlags) {
    AGChangedValueFlags_1 = 1 << 0,
    AGChangedValueFlagsRequiresMainThread = 1 << 1,
};

#endif /* AGChangedValueFlags_h */
