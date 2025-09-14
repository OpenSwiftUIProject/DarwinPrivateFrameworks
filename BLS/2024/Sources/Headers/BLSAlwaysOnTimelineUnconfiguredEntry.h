//
//  BLSAlwaysOnTimelineUnconfiguredEntry.h
//  BacklightServices

#ifndef BLSAlwaysOnTimelineUnconfiguredEntry_h
#define BLSAlwaysOnTimelineUnconfiguredEntry_h

#include "BLSAlwaysOnTimelineEntry.h"
#include "BLSUpdateFidelity.h"
#include <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLSAlwaysOnTimelineUnconfiguredEntry : BLSAlwaysOnTimelineEntry

@property (nonatomic) BLSUpdateFidelity requestedFidelity;
@property (retain, nonatomic, nullable) id <NSObject, NSCopying> timelineIdentifier;
@property (nonatomic, getter=isAnimated) BOOL animated;
@property (nonatomic) NSTimeInterval duration;
@property (retain, nonatomic, nullable) id <NSObject> userObject;

+ (instancetype)entryForPresentationTime:(NSDate *)time withRequestedFidelity:(BLSUpdateFidelity)fidelity;
+ (instancetype)entryForPresentationTime:(NSDate *)time;
+ (instancetype)entryForPresentationTime:(NSDate *)time withRequestedFidelity:(BLSUpdateFidelity)fidelity animated:(BOOL)animated userObject:(nullable id <NSObject>)object;
+ (instancetype)entryForPresentationTime:(NSDate *)time animated:(BOOL)animated userObject:(nullable id <NSObject>)object;

- (instancetype)initWithPresentationTime:(NSDate *)time requestedFidelity:(BLSUpdateFidelity)fidelity animated:(BOOL)animated duration:(NSTimeInterval)duration timelineIdentifier:(nullable id <NSObject, NSCopying>)identifier userObject:(nullable id <NSObject>)object;

@end

NS_ASSUME_NONNULL_END

#endif /* BLSAlwaysOnTimelineUnconfiguredEntry_h */
