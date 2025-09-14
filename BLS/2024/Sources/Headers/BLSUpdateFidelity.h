//
//  BLSUpdateFidelity.h
//  BacklightServices

#ifndef BLSUpdateFidelity_h
#define BLSUpdateFidelity_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BLSUpdateFidelity) {
    BLSUpdateFidelityUnspecified = -1,
    BLSUpdateFidelityNever = 0,
    BLSUpdateFidelityMinutes = 1,
    BLSUpdateFidelitySeconds = 2,
    BLSUpdateFidelityMilliseconds = 3
};

/**
 * Returns a string representation of the BLSUpdateFidelity value.
 *
 * @param fidelity The update fidelity value to convert
 * @return A string representation: "Unspecified", "Never", "Minutes", "Seconds", or "Milliseconds"
 */
FOUNDATION_EXPORT NSString * _Nonnull NSStringFromBLSUpdateFidelity(BLSUpdateFidelity fidelity);

/**
 * Returns an abbreviated string representation of the BLSUpdateFidelity value.
 *
 * @param fidelity The update fidelity value to convert
 * @return An abbreviated string: "?", "Ø", "m", "s", or "ms"
 */
FOUNDATION_EXPORT NSString * _Nonnull NSStringAbbreviatedFromBLSUpdateFidelity(BLSUpdateFidelity fidelity);

NS_ASSUME_NONNULL_END

#endif /* BLSUpdateFidelity_h */
