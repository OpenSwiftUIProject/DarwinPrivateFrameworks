//
//  AGComparisonMode.h
//
//
//  Created by Kyle on 2023/12/20.
//

#ifndef AGComparisonMode_h
#define AGComparisonMode_h

#include "AGBase.h"

typedef AG_ENUM(uint8_t, AGComparisonMode){
    AGComparisonModeBitwise = 0,
    AGComparisonModeIndirect = 1,
    AGComparisonModeEquatableUnlessPOD = 2,
    AGComparisonModeEquatableAlways = 3,
};

typedef AG_OPTIONS(uint32_t, AGComparisonOptions){
    AGComparisonOptionsComparisonModeMask = 0xff,

    AGComparisonOptionsCopyOnWrite = 1 << 8,
    AGComparisonOptionsFetchLayoutsSynchronously = 1 << 9,
    AGComparisonOptionsReportFailures = 1ul << 31, // -1 signed int
};

#endif /* AGComparisonMode_h */
