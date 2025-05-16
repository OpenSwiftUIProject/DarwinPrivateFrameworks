//
//  AGAttributeType.h
//
//
//  Created by Kyle on 2024/2/17.
//

#ifndef AGAttributeType_h
#define AGAttributeType_h

#include "AGAttributeTypeFlags.h"
#include "AGBase.h"
#include "AGTypeID.h"

AG_ASSUME_NONNULL_BEGIN

typedef struct AGClosureStorage {
    void *function;
    void *context;
} AGClosureStorage;

typedef struct AGAttributeVTable {
} AGAttributeVTable;

typedef struct AGAttributeType {
    AGTypeID typeID;
    AGTypeID valueTypeID;

    AGClosureStorage updateClosure;

    AGAttributeVTable *_Nullable callbacks;
    AGAttributeTypeFlags flags;

    // set after construction
    uint32_t offset;
    const unsigned char *_Nullable layout;

    AGTypeID initialTypeID;
    void *initialBodyTypeID;
} AGAttributeType;

AG_ASSUME_NONNULL_END

#endif /* AGAttributeType_h */
