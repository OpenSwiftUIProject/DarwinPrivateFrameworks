//
//  BLSAlwaysOnPeriodicTimeline.h
//  BacklightServices

#ifndef BLSAlwaysOnPeriodicTimeline_h
#define BLSAlwaysOnPeriodicTimeline_h

#include "BLSAlwaysOnTimeline.h"
#include "BLSAlwaysOnTimelineEntry.h"
#include "BLSAlwaysOnTimelineUnconfiguredEntry.h"
#include "BLSUpdateFidelity.h"
#include <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLSAlwaysOnPeriodicTimeline : BLSAlwaysOnTimeline {
    NSTimeInterval _periodicInterval;
    NSDate *_periodicStart;
}

- (instancetype)initWithUpdateInterval:(NSTimeInterval)interval startDate:(NSDate *)date identifier:(id <NSObject, NSCopying>)identifier configure:(nullable void (^)(BLSAlwaysOnTimelineEntry *entry, BLSAlwaysOnTimelineEntry * _Nullable previousEntry))configure;
- (NSString *)description;
- (BLSUpdateFidelity)requestedFidelityForStartEntryInDateInterval:(NSDateInterval *)interval withPreviousEntry:(nullable BLSAlwaysOnTimelineEntry *)entry;
- (NSArray<BLSAlwaysOnTimelineUnconfiguredEntry *> *)unconfiguredEntriesForDateInterval:(NSDateInterval *)interval previousEntry:(nullable BLSAlwaysOnTimelineEntry *)entry;

@end

NS_ASSUME_NONNULL_END

#endif /* BLSAlwaysOnPeriodicTimeline_h */
