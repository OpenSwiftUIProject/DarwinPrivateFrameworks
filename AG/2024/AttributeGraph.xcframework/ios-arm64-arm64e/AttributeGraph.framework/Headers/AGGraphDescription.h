//
//  AGGraphDescription.h
//  AttributeGraph

#ifndef AGGraphDescription_h
#define AGGraphDescription_h

#include <AttributeGraph/AGBase.h>
#include <AttributeGraph/AGGraph.h>

AG_ASSUME_NONNULL_BEGIN

AG_IMPLICIT_BRIDGING_ENABLED

AG_EXTERN_C_BEGIN

#if AG_OBJC_FOUNDATION

AG_EXPORT
const CFStringRef AGDescriptionFormat AG_SWIFT_NAME(AGGraphRef.descriptionFormat);

AG_EXPORT
const CFStringRef AGDescriptionIncludeValues AG_SWIFT_NAME(AGGraphRef.descriptionIncludeValues);

static const CFStringRef AGDescriptionFormatDot AG_SWIFT_NAME(AGGraphRef.descriptionFormatDot) = CFSTR("graph/dot");

static const CFStringRef AGDescriptionFormatDictionary AG_SWIFT_NAME(AGGraphRef.descriptionFormatDictionary) = CFSTR("graph/dict");

static const CFStringRef AGDescriptionAllGraphs AG_SWIFT_NAME(AGGraphRef.descriptionAllGraphs) = CFSTR("all_graphs");

#endif

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGGraphArchiveJSON(char const * _Nullable name) AG_SWIFT_NAME(AGGraphRef.archiveJSON(name:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGGraphArchiveJSON2(char const * _Nullable name, uint8_t options) AG_SWIFT_NAME(AGGraphRef.archiveJSON(name:options:));

AG_EXPORT
AG_REFINED_FOR_SWIFT
_Nullable CFTypeRef AGGraphDescription(_Nullable AGGraphRef graph, CFDictionaryRef options) AG_SWIFT_NAME(AGGraphRef.description(_:options:));

AG_EXTERN_C_END

AG_IMPLICIT_BRIDGING_DISABLED

AG_ASSUME_NONNULL_END

#endif /* AGGraphDescription_h */
