//
//  GFGestureRelation.h
//  Gestures

#ifndef GFGestureRelation_h
#define GFGestureRelation_h

#include <Gestures/GFBase.h>

typedef GF_ENUM(NSInteger, GFGestureRelationType) {
    GFGestureRelationTypeCanExclude = 0,
    GFGestureRelationTypeCanBeExcluded = 1,
    GFGestureRelationTypeCanExcludeActive = 2,
    GFGestureRelationTypeCanBeExcludedWhenActive = 3,
    GFGestureRelationTypeRequiresFailure = 4,
    GFGestureRelationTypeRequiredToFail = 5,
};

typedef GF_ENUM(NSInteger, GFGestureRelationRole) {
    GFGestureRelationRoleRegular = 0,
    GFGestureRelationRoleBlocking = 1,
};

#endif /* GFGestureRelation_h */
