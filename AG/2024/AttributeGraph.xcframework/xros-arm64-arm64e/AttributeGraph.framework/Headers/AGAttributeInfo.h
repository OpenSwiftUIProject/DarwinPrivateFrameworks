//
//  AGAttributeInfo.h
//  AttributeGraph

#ifndef AGAttributeInfo_h
#define AGAttributeInfo_h

#include <AttributeGraph/AGBase.h>
#include <AttributeGraph/AGAttributeType.h>

AG_ASSUME_NONNULL_BEGIN

typedef struct AGAttributeInfo {
    const AGAttributeType* type;
    const void *body;
} AGAttributeInfo;

AG_ASSUME_NONNULL_END

#endif /* AGAttributeInfo_h */
