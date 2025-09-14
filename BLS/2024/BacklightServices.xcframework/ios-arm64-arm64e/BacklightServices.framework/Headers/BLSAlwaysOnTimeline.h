//
//  BLSAlwaysOnTimeline.h
//  BacklightServices

#ifndef BLSAlwaysOnTimeline_h
#define BLSAlwaysOnTimeline_h

#include "BLSUpdateFidelity.h"
#include "BLSAlwaysOnTimelineEntry.h"
#include "BLSAlwaysOnTimelineUnconfiguredEntry.h"
#include "BLSAlwaysOnFrameSpecifier.h"
#include <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLSAlwaysOnTimeline : NSObject {
    id /* block */ _configureEntryBlock;
}

@property (readonly, nonatomic) id <NSObject, NSCopying> identifier;

+ (instancetype)emptyTimelineWithIdentifier:(id <NSObject, NSCopying>)identifier;
+ (instancetype)timelineWithPerMinuteUpdateFrequency:(NSInteger)frequency identifier:(id <NSObject, NSCopying>)identifier configure:(nullable void (^)(BLSAlwaysOnTimelineEntry *entry, BLSAlwaysOnTimelineEntry * _Nullable previousEntry))configure;
+ (instancetype)everyMinuteTimelineWithIdentifier:(id <NSObject, NSCopying>)identifier configure:(nullable void (^)(BLSAlwaysOnTimelineEntry *entry, BLSAlwaysOnTimelineEntry * _Nullable previousEntry))configure;
+ (instancetype)timelineWithUpdateInterval:(NSTimeInterval)interval startDate:(NSDate *)date identifier:(id <NSObject, NSCopying>)identifier configure:(nullable void (^)(BLSAlwaysOnTimelineEntry *entry, BLSAlwaysOnTimelineEntry * _Nullable previousEntry))configure;
+ (instancetype)timelineWithEntries:(NSArray<BLSAlwaysOnTimelineUnconfiguredEntry *> *)entries identifier:(id <NSObject, NSCopying>)identifier configure:(nullable void (^)(BLSAlwaysOnTimelineEntry *entry, BLSAlwaysOnTimelineEntry * _Nullable previousEntry))configure;
+ (NSRange)rangeOfEntries:(NSArray<BLSAlwaysOnTimelineEntry *> *)entries forDateInterval:(NSDateInterval *)interval shouldIncludePrevious:(BOOL)previous;
+ (NSArray<BLSAlwaysOnFrameSpecifier *> *)constructFrameSpecifiersForTimelines:(NSArray<BLSAlwaysOnTimeline *> *)timelines dateInterval:(NSDateInterval *)interval shouldConstructStartSpecifier:(BOOL)specifier framesPerSecond:(double)second previousSpecifier:(nullable BLSAlwaysOnFrameSpecifier *)specifier;
+ (BLSUpdateFidelity)requestedFidelityForTimelines:(NSArray<BLSAlwaysOnTimeline *> *)timelines inDateInterval:(NSDateInterval *)interval;

- (instancetype)initWithIdentifier:(id <NSObject, NSCopying>)identifier configure:(nullable void (^)(BLSAlwaysOnTimelineEntry *entry, BLSAlwaysOnTimelineEntry * _Nullable previousEntry))configure;
- (NSString *)description;
- (BLSAlwaysOnTimelineEntry *)configureEntry:(BLSAlwaysOnTimelineEntry *)entry previousEntry:(nullable BLSAlwaysOnTimelineEntry *)entry;
- (NSArray<BLSAlwaysOnTimelineEntry *> *)configureEntries:(NSArray<BLSAlwaysOnTimelineEntry *> *)entries previousEntry:(nullable BLSAlwaysOnTimelineEntry *)entry;
- (BLSUpdateFidelity)requestedFidelityForStartEntryInDateInterval:(NSDateInterval *)interval withPreviousEntry:(nullable BLSAlwaysOnTimelineEntry *)entry;
- (nullable NSArray<BLSAlwaysOnTimelineUnconfiguredEntry *> *)unconfiguredEntriesForDateInterval:(NSDateInterval *)interval previousEntry:(nullable BLSAlwaysOnTimelineEntry *)entry;
- (BLSUpdateFidelity)estimatedFidelityForPresentationTime:(NSDate *)time nextPresentationTime:(NSDate *)time;

@end

NS_ASSUME_NONNULL_END

#endif /* BLSAlwaysOnTimeline_h */
