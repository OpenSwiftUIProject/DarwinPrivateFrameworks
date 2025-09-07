//
//  RBBase.h
//  RenderBox

#pragma once

#if DEBUG
#define RB_ASSERTION
#else
#undef RB_ASSERTION
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
#define RB_NOEXCEPT noexcept
#else
#define RB_NOEXCEPT
#endif

#if defined(__GNUC__)
#define RB_INLINE __inline__ __attribute__((always_inline))
#elif defined(__cplusplus)
#define RB_INLINE inline
#else
#define RB_INLINE
#endif

#if defined(__cplusplus)
#define RB_CONSTEXPR constexpr
#else
#define RB_CONSTEXPR
#endif

#include <CoreFoundation/CoreFoundation.h>
#include <stdint.h>
#include <stdbool.h>
#include "RBSwiftSupport.h"
#include "RBTargetConditionals.h"

#define RB_ENUM CF_ENUM
#define RB_CLOSED_ENUM CF_CLOSED_ENUM
#define RB_OPTIONS CF_OPTIONS
#define RB_EXTERN_C_BEGIN CF_EXTERN_C_BEGIN
#define RB_EXTERN_C_END CF_EXTERN_C_END
#define RB_ASSUME_NONNULL_BEGIN CF_ASSUME_NONNULL_BEGIN
#define RB_ASSUME_NONNULL_END CF_ASSUME_NONNULL_END
#define RB_IMPLICIT_BRIDGING_ENABLED CF_IMPLICIT_BRIDGING_ENABLED
#define RB_IMPLICIT_BRIDGING_DISABLED CF_IMPLICIT_BRIDGING_DISABLED
#define RB_EXPORT CF_EXPORT
#define RB_BRIDGED_TYPE CF_BRIDGED_TYPE

#if RB_TARGET_OS_DARWIN && __RBJC__
#define RB_RBJC_FOUNDATION 1
#else
#define RB_RBJC_FOUNDATION 0
#endif /* TARGET_OS_DARWIN && __RBJC__ */

