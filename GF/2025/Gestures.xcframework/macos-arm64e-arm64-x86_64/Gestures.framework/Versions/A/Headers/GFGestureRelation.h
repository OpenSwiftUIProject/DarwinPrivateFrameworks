//
//  GFGestureRelation.h
//  Gestures

#ifndef GFGestureRelation_h
#define GFGestureRelation_h

#include <Gestures/GSBase.h>

typedef GS_ENUM(NSInteger, GFGestureRelationType) {
    GFGestureRelationTypeCanExclude = 0,
    GFGestureRelationTypeCanBeExcluded = 1,
    GFGestureRelationTypeCanExcludeActive = 2,
    GFGestureRelationTypeCanBeExcludedWhenActive = 3,
    GFGestureRelationTypeRequiresFailure = 4,
    GFGestureRelationTypeRequiredToFail = 5,
};

typedef GS_ENUM(NSInteger, GFGestureRelationRole) {
    GFGestureRelationRoleRegular = 0,
    GFGestureRelationRoleBlocking = 1,
};

#endif /* GFGestureRelation_h */
