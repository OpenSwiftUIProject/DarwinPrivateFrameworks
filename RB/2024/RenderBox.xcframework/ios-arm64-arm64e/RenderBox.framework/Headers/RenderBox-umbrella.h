#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif

#include "RBBase.h"
#include "RBUUID.h"

FOUNDATION_EXPORT double RenderBoxVersionNumber;
FOUNDATION_EXPORT const unsigned char RenderBoxVersionString[];
