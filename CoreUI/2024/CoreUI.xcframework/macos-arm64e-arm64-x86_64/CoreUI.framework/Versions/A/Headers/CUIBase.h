//
//  CUIBase.h
//  CoreUI

#ifndef CUIBase_h
#define CUIBase_h

#if DEBUG
#define CUI_ASSERTION
#else
#undef CUI_ASSERTION
#endif

#if __has_attribute(cold)
#define __cold __attribute__((__cold__))
#else
#define __cold
#endif

#if __has_attribute(noreturn)
#define __dead2 __attribute__((__noreturn__))
#else
#define __dead2
#endif

#if defined(__cplusplus)
#define CUI_NOEXCEPT noexcept
#else
#define CUI_NOEXCEPT
#endif

#if defined(__GNUC__)
#define CUI_INLINE __inline__ __attribute__((always_inline))
#elif defined(__cplusplus)
#define CUI_INLINE inline
#else
#define CUI_INLINE
#endif

#if defined(__cplusplus)
#define CUI_CONSTEXPR constexpr
#else
#define CUI_CONSTEXPR
#endif

#include <CoreUI/CUISwiftSupport.h>
#include <CoreUI/CUITargetConditionals.h>
#include <CoreFoundation/CoreFoundation.h>
#include <stdbool.h>
#include <stdint.h>

#define CUI_ENUM CF_ENUM
#define CUI_CLOSED_ENUM CF_CLOSED_ENUM
#define CUI_OPTIONS CF_OPTIONS
#define CUI_EXTERN_C_BEGIN CF_EXTERN_C_BEGIN
#define CUI_EXTERN_C_END CF_EXTERN_C_END
#define CUI_ASSUME_NONNULL_BEGIN CF_ASSUME_NONNULL_BEGIN
#define CUI_ASSUME_NONNULL_END CF_ASSUME_NONNULL_END
#define CUI_IMPLICIT_BRIDGING_ENABLED CF_IMPLICIT_BRIDGING_ENABLED
#define CUI_IMPLICIT_BRIDGING_DISABLED CF_IMPLICIT_BRIDGING_DISABLED
#define CUI_EXPORT CF_EXPORT
#define CUI_BRIDGED_TYPE CF_BRIDGED_TYPE

#if CUI_TARGET_OS_DARWIN && __OBJC__
#define CUI_OBJC_FOUNDATION 1
#else
#define CUI_OBJC_FOUNDATION 0
#endif /* CUI_TARGET_OS_DARWIN && __OBJC__ */

// Marks APIs which format strings by taking a format string and optional varargs as arguments
#if !defined(CUI_FORMAT_FUNCTION)
    #if (__GNUC__*10+__GNUC_MINOR__ >= 42)
    #define CUI_FORMAT_FUNCTION(F,A) __attribute__((format(__NSString__, F, A)))
    #else
    #define CUI_FORMAT_FUNCTION(F,A)
    #endif
#endif

#endif /* CUIBase_h */
