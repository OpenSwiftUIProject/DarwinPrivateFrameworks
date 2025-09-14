//
//  BLSAlwaysOnFrameSpecifier.h
//  BacklightServices

#ifndef BLSAlwaysOnFrameSpecifier_h
#define BLSAlwaysOnFrameSpecifier_h

#include "BLSUpdateFidelity.h"
#include "BLSAlwaysOnTimelineEntrySpecifier.h"
#include <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLSAlwaysOnFrameSpecifier : NSObject <NSCopying> {
    BLSUpdateFidelity _grantedFidelity;
    os_unfair_lock _lock;
    NSArray<BLSAlwaysOnTimelineEntrySpecifier *> *_entrySpecifiers;
    NSDateInterval *_presentationInterval;
}

@property BLSUpdateFidelity grantedFidelity;
@property (readonly, nullable) NSArray<BLSAlwaysOnTimelineEntrySpecifier *> *entrySpecifiers;
@property (readonly) NSDateInterval *presentationInterval;
@property (readonly) BLSUpdateFidelity requestedFidelity;

+ (NSString *)loggingStringForPresentationInterval:(NSDateInterval *)interval;
+ (NSString *)shortLoggingStringForPresentationInterval:(NSDateInterval *)interval;

- (instancetype)initWithTimelineEntrySpecifiers:(NSArray<BLSAlwaysOnTimelineEntrySpecifier *> *)specifiers presentationInterval:(NSDateInterval *)interval;
- (nullable BLSAlwaysOnTimelineEntrySpecifier *)entrySpecifierForTimelineIdentifier:(id)identifier;
- (NSComparisonResult)compare:(BLSAlwaysOnFrameSpecifier *)compare;
- (nullable BLSAlwaysOnFrameSpecifier *)correctedSpecifierWithNextSpecifier:(BLSAlwaysOnFrameSpecifier *)specifier;
- (NSString *)description;
- (NSString *)debugDescription;
- (BOOL)isEqual:(id)equal;
- (NSUInteger)hash;
- (id)copyWithZone:(NSZone *)zone;

@end

NS_ASSUME_NONNULL_END

#endif /* BLSAlwaysOnFrameSpecifier_h */
