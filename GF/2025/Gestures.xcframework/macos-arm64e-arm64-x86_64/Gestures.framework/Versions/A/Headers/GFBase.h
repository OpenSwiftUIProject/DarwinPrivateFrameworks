//
//  GFBase.h
//  Gestures

#ifndef GFBase_h
#define GFBase_h

#include <CoreFoundation/CoreFoundation.h>
#include <stdbool.h>
#include <stdint.h>

#define GF_ENUM CF_ENUM
#define GF_CLOSED_ENUM CF_CLOSED_ENUM
#define GF_OPTIONS CF_OPTIONS
#define GF_EXTERN_C_BEGIN CF_EXTERN_C_BEGIN
#define GF_EXTERN_C_END CF_EXTERN_C_END
#define GF_ASSUME_NONNULL_BEGIN CF_ASSUME_NONNULL_BEGIN
#define GF_ASSUME_NONNULL_END CF_ASSUME_NONNULL_END
#define GF_EXPORT CF_EXPORT

#if __has_attribute(swift_name)
#define GF_SWIFT_NAME(_name) __attribute__((swift_name(#_name)))
#else
#define GF_SWIFT_NAME(_name)
#endif

#endif /* GFBase_h */
