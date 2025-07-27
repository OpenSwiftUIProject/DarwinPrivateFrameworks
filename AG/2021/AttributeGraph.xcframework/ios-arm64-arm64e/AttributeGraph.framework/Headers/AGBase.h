//
//  AGBase.h
//  AttributeGraph

#ifndef AGBase_h
#define AGBase_h

#if DEBUG
#define AG_ASSERTION
#else
#undef AG_ASSERTION
#endif

#if __has_attribute(cold)
#define __cold          __attribute__((__cold__))
#else
#define __cold
#endif

#if __has_attribute(noreturn)
#define __dead2         __attribute__((__noreturn__))
#else
#define __dead2
#endif

#if defined(__cplusplus)
#define AG_NOEXCEPT noexcept
#else
#define AG_NOEXCEPT
#endif

#if defined(__GNUC__)
#define AG_INLINE __inline__ __attribute__((always_inline))
#elif defined(__cplusplus)
#define AG_INLINE inline
#else
#define AG_INLINE
#endif

#if defined(__cplusplus)
#define AG_CONSTEXPR constexpr
#else
#define AG_CONSTEXPR
#endif

#if __has_include(<ptrcheck.h>) // Fix conflict define issue of the SDK
#include <ptrcheck.h>
#define AG_COUNTED_BY(N) __counted_by(N)
#else
#if !defined(__counted_by)
#if __has_attribute(__counted_by__)
#define __counted_by(N) __attribute__((__counted_by__(N)))
#else
#define __counted_by(N)
#endif
#endif
#define AG_COUNTED_BY(N) __counted_by(N)
#endif

#include <CoreFoundation/CoreFoundation.h>
#include <TargetConditionals.h>
#ifndef TARGET_OS_DARWIN
#define TARGET_OS_DARWIN TARGET_OS_MAC
#endif
#include "AGSwiftSupport.h"

#define AG_ENUM CF_ENUM
#define AG_CLOSED_ENUM CF_CLOSED_ENUM
#define AG_OPTIONS CF_OPTIONS
#define AG_EXTERN_C_BEGIN CF_EXTERN_C_BEGIN
#define AG_EXTERN_C_END CF_EXTERN_C_END
#define AG_ASSUME_NONNULL_BEGIN CF_ASSUME_NONNULL_BEGIN
#define AG_ASSUME_NONNULL_END CF_ASSUME_NONNULL_END
#define AG_IMPLICIT_BRIDGING_ENABLED CF_IMPLICIT_BRIDGING_ENABLED
#define AG_IMPLICIT_BRIDGING_DISABLED CF_IMPLICIT_BRIDGING_DISABLED
#define AG_EXPORT CF_EXPORT
#define AG_BRIDGED_TYPE CF_BRIDGED_TYPE

#define AG_TARGET_OS_DARWIN       1

#if AG_TARGET_OS_DARWIN && __OBJC__
#define AG_OBJC_FOUNDATION 1
#else
#define AG_OBJC_FOUNDATION 0
#endif /* AG_TARGET_OS_DARWIN && __OBJC__ */

#endif /* AGBase_h */
