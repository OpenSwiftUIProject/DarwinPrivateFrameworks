//
//  CUIUserInterfaceSizeClass.h
//  CoreUI
//
//  Audited for 918.3
//  Status: Complete

#ifndef CUIUserInterfaceSizeClass_h
#define CUIUserInterfaceSizeClass_h

#import <Foundation/Foundation.h>
#import <CoreUI/CUIBase.h>

typedef CUI_CLOSED_ENUM(int8_t, CUIUserInterfaceSizeClass) {
    CUIUserInterfaceSizeClassAny      = 0,
    CUIUserInterfaceSizeClassCompact  = 1,
    CUIUserInterfaceSizeClassRegular  = 2,
};

#endif /* CUIUserInterfaceSizeClass_h */
