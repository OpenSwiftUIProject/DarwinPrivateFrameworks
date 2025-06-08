//
//  CUISubtype.h
//  CoreUI
//
//  Audited for 918.3
//  Status: Complete

#ifndef CUISubtype_h
#define CUISubtype_h

#import <Foundation/Foundation.h>
#import <CoreUI/CUIBase.h>

typedef CUI_CLOSED_ENUM(NSUInteger, CUISubtype) {
    CUISubtypeNormal       = 0,
    CUISubtypeAppleWatch38 = 320,
    CUISubtypeAppleWatch42 = 384,
    CUISubtypeIPhone4Inch  = 568,
};

#endif /* CUISubtype_h */
