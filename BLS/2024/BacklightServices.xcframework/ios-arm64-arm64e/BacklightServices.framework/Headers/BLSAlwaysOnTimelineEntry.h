//
//  BLSAlwaysOnTimelineEntry.h
//  BacklightServices

#ifndef BLSAlwaysOnTimelineEntry_h
#define BLSAlwaysOnTimelineEntry_h

#include "BLSUpdateFidelity.h"
#include <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLSAlwaysOnTimelineEntry : NSObject <NSCopying, NSMutableCopying>

@property (nonatomic) BLSUpdateFidelity requestedFidelity;
@property (nonatomic, getter=isAnimated) BOOL animated;
@property (nonatomic) NSTimeInterval duration;
@property (retain, nonatomic, nullable) id <NSObject> userObject;
@property (retain, nonatomic, nullable) id <NSObject, NSCopying> timelineIdentifier;
@property (readonly, nonatomic) NSDate *presentationTime;

+ (NSString *)loggingStringForPresentationTime:(NSDate *)time;
+ (NSString *)shortLoggingStringForPresentationTime:(NSDate *)time;

- (instancetype)initWithPresentationTime:(NSDate *)time requestedFidelity:(BLSUpdateFidelity)fidelity animated:(BOOL)animated duration:(NSTimeInterval)duration timelineIdentifier:(nullable id <NSObject, NSCopying>)identifier userObject:(nullable id <NSObject>)object;
- (NSComparisonResult)compare:(BLSAlwaysOnTimelineEntry *)compare;
- (NSString *)description;
- (NSString *)debugDescription;
- (BOOL)isEqual:(id)equal;
- (NSUInteger)hash;
- (id)copyWithZone:(nullable NSZone *)zone;
- (id)mutableCopyWithZone:(nullable NSZone *)zone;

@end

NS_ASSUME_NONNULL_END

#endif /* BLSAlwaysOnTimelineEntry_h */
