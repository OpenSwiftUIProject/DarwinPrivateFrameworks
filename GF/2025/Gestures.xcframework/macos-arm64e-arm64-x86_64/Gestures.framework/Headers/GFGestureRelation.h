//
//  GFGestureRelation.h
//  Gestures

#ifndef GFGestureRelation_h
#define GFGestureRelation_h

#include <Gestures/GSBase.h>

GS_EXTERN_C_BEGIN

/// Gesture relation type.
/// rawValue 0: canExclude, 1: canBeExcluded, 2: failureRequirement, 4: requires, 5: requiredBy
typedef struct GFGestureRelationType {
    NSInteger rawValue;
} GFGestureRelationType;

/// Gesture relation role.
/// rawValue 0: regular, 1: blocking
typedef struct GFGestureRelationRole {
    NSInteger rawValue;
} GFGestureRelationRole;

GS_EXTERN_C_END

#endif /* GFGestureRelation_h */
