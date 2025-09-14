//
//  BLSAlwaysOnTimelineEntrySpecifier.h
//  BacklightServices

#ifndef BLSAlwaysOnTimelineEntrySpecifier_h
#define BLSAlwaysOnTimelineEntrySpecifier_h

#include "BLSAlwaysOnTimelineEntry.h"
#include "BLSUpdateFidelity.h"
#include <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLSAlwaysOnTimelineEntrySpecifier : NSObject <NSCopying> {
    BLSUpdateFidelity _requestedFidelity;
    os_unfair_lock _lock;
    BOOL _didChange;
    BLSAlwaysOnTimelineEntry *_timelineEntry;
    BLSUpdateFidelity _grantedFidelity;
    double _percentComplete;
    BLSAlwaysOnTimelineEntry *_previousTimelineEntry;
}

@property BOOL didChange;
@property BLSUpdateFidelity grantedFidelity;
@property BLSUpdateFidelity requestedFidelity;
@property (readonly) BLSAlwaysOnTimelineEntry *timelineEntry;
@property (readonly) double percentComplete;
@property (readonly, nullable) BLSAlwaysOnTimelineEntry *previousTimelineEntry;

- (instancetype)initWithTimelineEntry:(BLSAlwaysOnTimelineEntry *)entry percentComplete:(double)complete previousTimelineEntry:(nullable BLSAlwaysOnTimelineEntry *)entry didChange:(BOOL)change;
- (NSComparisonResult)compare:(BLSAlwaysOnTimelineEntrySpecifier *)compare;
- (NSString *)description;
- (void)appendFidelityToTarget:(id)target;
- (NSString *)debugDescription;
- (BOOL)isEqual:(id)equal;
- (NSUInteger)hash;
- (id)copyWithZone:(nullable NSZone *)zone;

@end

NS_ASSUME_NONNULL_END

#endif /* BLSAlwaysOnTimelineEntrySpecifier_h */
