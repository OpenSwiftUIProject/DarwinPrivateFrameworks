//
//  AGVersion.h
//  AttributeGraph

#ifndef AGVersion_h
#define AGVersion_h

#include "AGBase.h"

/* UPDATE_BEGIN */
#define ATTRIBUTEGRAPH_RELEASE 2024
/* UPDATE_END */

#define ATTRIBUTEGRAPH_RELEASE_2021 2021
#define ATTRIBUTEGRAPH_RELEASE_2024 2024

#ifndef ATTRIBUTEGRAPH_RELEASE
#define ATTRIBUTEGRAPH_RELEASE ATTRIBUTEGRAPH_RELEASE_2024
#endif

AG_EXTERN_C_BEGIN

AG_EXPORT const uint64_t AGVersion;

AG_EXTERN_C_END

#endif /* AGVersion_h */
