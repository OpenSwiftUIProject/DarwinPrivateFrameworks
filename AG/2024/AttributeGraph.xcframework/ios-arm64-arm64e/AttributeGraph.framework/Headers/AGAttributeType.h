//
//  AGAttributeType.h
//  AttributeGraph

#ifndef AGAttributeType_h
#define AGAttributeType_h

#include <AttributeGraph/AGBase.h>
#include <AttributeGraph/AGTypeID.h>

AG_ASSUME_NONNULL_BEGIN

typedef struct AGAttributeType {
    AGTypeID typeID;
    AGTypeID valueTypeID;
    // TODO
} AGAttributeType;

AG_ASSUME_NONNULL_END

#endif /* AGAttributeType_h */
