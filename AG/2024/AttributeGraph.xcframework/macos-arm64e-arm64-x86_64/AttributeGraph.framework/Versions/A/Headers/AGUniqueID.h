//
//  AGUniqueID.h
//  AttributeGraph
//
//  Audited for 6.5.1
//  Status: Complete

#ifndef AGUniqueID_h
#define AGUniqueID_h

#include <AttributeGraph/AGBase.h>
typedef u_long AGUniqueID AG_SWIFT_NAME(UniqueID);

AG_EXTERN_C_BEGIN
AG_EXPORT
AG_REFINED_FOR_SWIFT
AGUniqueID AGMakeUniqueID(void) AG_SWIFT_NAME(makeUniqueID());
AG_EXTERN_C_END

#endif /* AGUniqueID_h */
