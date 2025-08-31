//
//  AGWeakAttribute.h
//  AttributeGraph

#ifndef AGWeakAttribute_hpp
#define AGWeakAttribute_hpp

#include <AttributeGraph/AGBase.h>
#include <AttributeGraph/AGAttribute.h>
#include <AttributeGraph/AGWeakValue.h>

AG_ASSUME_NONNULL_BEGIN

typedef struct AG_SWIFT_NAME(AnyWeakAttribute) AGWeakAttribute {
    struct {
        AGAttribute identifier;
        uint32_t seed;
    } _details;
} AGWeakAttribute;

AG_EXTERN_C_BEGIN

AG_EXPORT
AG_REFINED_FOR_SWIFT
AGWeakAttribute AGCreateWeakAttribute(AGAttribute attribute);

AG_EXPORT
AG_REFINED_FOR_SWIFT
AGAttribute AGWeakAttributeGetAttribute(AGWeakAttribute weakAttribute);

AG_EXPORT
AG_REFINED_FOR_SWIFT
AGWeakValue AGGraphGetWeakValue(AGWeakAttribute weakAttribute, AGValueOptions options, AGTypeID type);

AG_EXTERN_C_END

AG_ASSUME_NONNULL_END

#endif /* AGWeakAttribute_h */
