//
//  CUISwiftSupport.h
//  CoreUI

#ifndef CUISwiftSupport_h
#define CUISwiftSupport_h

#if __has_attribute(swift_name)
#define CUI_SWIFT_NAME(_name) __attribute__((swift_name(#_name)))
#else
#define CUI_SWIFT_NAME
#endif

#if __has_attribute(swift_wrapper)
#define CUI_SWIFT_STRUCT __attribute__((swift_wrapper(struct)))
#else
#define CUI_SWIFT_STRUCT
#endif

#if __has_attribute(swift_private)
#define CUI_REFINED_FOR_SWIFT __attribute__((swift_private))
#else
#define CUI_REFINED_FOR_SWIFT
#endif

// MARK: - Call Convension

#define CUI_SWIFT_CC(CC) CUI_SWIFT_CC_##CC
// CUI_SWIFT_CC(c) is the C calling convention.
#define CUI_SWIFT_CC_c

// CUI_SWIFT_CC(swift) is the Swift calling convention.
#if __has_attribute(swiftcall)
#define CUI_SWIFT_CC_swift __attribute__((swiftcall))
#define CUI_SWIFT_CONTEXT __attribute__((swift_context))
#define CUI_SWIFT_ERROR_RESULT __attribute__((swift_error_result))
#define CUI_SWIFT_INDIRECT_RESULT __attribute__((swift_indirect_result))
#else
#define CUI_SWIFT_CC_swift
#define CUI_SWIFT_CONTEXT
#define CUI_SWIFT_ERROR_RESULT
#define CUI_SWIFT_INDIRECT_RESULT
#endif

#endif /* CUISwiftSupport_h */
