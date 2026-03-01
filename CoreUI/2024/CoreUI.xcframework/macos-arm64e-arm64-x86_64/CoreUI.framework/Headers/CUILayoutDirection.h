//
//  CUILayoutDirection.h
//  CoreUI
//
//  Audited for 918.3
//  Status: WIP

#ifndef CUILayoutDirection_h
#define CUILayoutDirection_h

#import <Foundation/Foundation.h>
#import <CoreUI/CUIBase.h>

typedef CUI_ENUM(NSInteger, CUILayoutDirection) {
    CUILayoutDirectionUnspecified = 0,
    CUILayoutDirection_1          = 1,
    CUILayoutDirection_2          = 2,
    CUILayoutDirection_3          = 3,
    CUILayoutDirectionRTL         = 4,
    CUILayoutDirectionLTR         = 5,
};

#endif /* CUILayoutDirection_h */
