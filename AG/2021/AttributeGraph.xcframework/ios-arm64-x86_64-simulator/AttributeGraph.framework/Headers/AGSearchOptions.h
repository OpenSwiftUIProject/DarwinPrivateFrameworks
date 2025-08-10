//
//  AGSearchOptions.h
//  AttributeGraph

#ifndef AGSearchOptions_h
#define AGSearchOptions_h

#include <AttributeGraph/AGBase.h>

typedef AG_OPTIONS(uint32_t, AGSearchOptions) {
    AGSearchOptionsSearchInputs = 1 << 0,
    AGSearchOptionsSearchOutputs = 1 << 1,
    AGSearchOptionsTraverseGraphContexts = 1 << 2,
} AG_SWIFT_NAME(SearchOptions);

#endif /* Header_h */
