//
//  CUIImageType.h
//  CoreUI
//
//  Audited for 918.3
//  Status: Complete

#ifndef CUIImageType_h
#define CUIImageType_h

#import <Foundation/Foundation.h>
#import <CoreUI/CUIBase.h>

typedef CUI_CLOSED_ENUM(NSInteger, CUIImageType) {
    CUIImageTypeNone                  = 0,
    CUIImageTypeHorizontal            = 1,
    CUIImageTypeVertical              = 2,
    CUIImageTypeHorizontalAndVertical = 3,
};

#endif /* CUIImageType_h */
