//
//  BLSBacklightFBSSceneEnvironment.h
//  BacklightServices

#ifndef BLSBacklightFBSSceneEnvironment_h
#define BLSBacklightFBSSceneEnvironment_h

#include "BLSAlwaysOnFrameSpecifier.h"
#include <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLSBacklightFBSSceneEnvironment : NSObject

- (void)invalidateAllTimelinesForReason:(NSString *)reason;

@end

NS_ASSUME_NONNULL_END

#endif /* BLSBacklightFBSSceneEnvironment_h */
