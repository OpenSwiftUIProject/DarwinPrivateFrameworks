//
//  AGClosure.h
//  AttributeGraph

#ifndef AGClosure_h
#define AGClosure_h

#include <AttributeGraph/AGBase.h>

AG_ASSUME_NONNULL_BEGIN

AG_EXTERN_C_BEGIN

typedef struct AGClosureStorage {
    const void *thunk;
    const void *_Nullable context;
} AGClosureStorage AG_SWIFT_NAME(_AGClosureStorage);

AG_EXPORT
AG_REFINED_FOR_SWIFT
AGClosureStorage AGRetainClosure(void (*thunk)(void *_Nullable context AG_SWIFT_CONTEXT) AG_SWIFT_CC(swift),
                                 void *_Nullable context);

AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGReleaseClosure(AGClosureStorage closure);

AG_EXTERN_C_END

AG_ASSUME_NONNULL_END

#endif /* AGClosure_h */
