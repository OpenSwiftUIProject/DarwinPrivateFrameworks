//
//  RBSwiftSupport.h
//  RenderBox

#pragma once

#if __has_attribute(swift_name)
#define RB_SWIFT_NAME(_name) __attribute__((swift_name(#_name)))
#else
#define RB_SWIFT_NAME
#endif

#if __has_attribute(swift_wrapper)
#define RB_SWIFT_STRUCT __attribute__((swift_wrapper(struct)))
#else
#define RB_SWIFT_STRUCT
#endif

#if __has_attribute(swift_private)
#define RB_REFINED_FOR_SWIFT __attribute__((swift_private))
#else
#define RB_REFINED_FOR_SWIFT
#endif

// MARK: - Call Convension

#define RB_SWIFT_CC(CC) RB_SWIFT_CC_##CC
// RB_SWIFT_CC(c) is the C calling convention.
#define RB_SWIFT_CC_c

// RB_SWIFT_CC(swift) is the Swift calling convention.
#if __has_attribute(swiftcall)
#define RB_SWIFT_CC_swift __attribute__((swiftcall))
#define RB_SWIFT_CONTEXT __attribute__((swift_context))
#define RB_SWIFT_ERROR_RESULT __attribute__((swift_error_result))
#define RB_SWIFT_INDIRECT_RESULT __attribute__((swift_indirect_result))
#else
#define RB_SWIFT_CC_swift
#define RB_SWIFT_CONTEXT
#define RB_SWIFT_ERROR_RESULT
#define RB_SWIFT_INDIRECT_RESULT
#endif

