//
//  CUIDeviceIdiom.h
//  CoreUI
//
//  Audited for 918.3
//  Status: Complete

#ifndef CUIDeviceIdiom_h
#define CUIDeviceIdiom_h

#import <Foundation/Foundation.h>
#import <CoreUI/CUIBase.h>

typedef CUI_CLOSED_ENUM(NSInteger, CUIDeviceIdiom) {
    CUIDeviceIdiomUniversal  = 0,
    CUIDeviceIdiomIPhone     = 1,
    CUIDeviceIdiomIPad       = 2,
    CUIDeviceIdiomAppleTV    = 3,
    CUIDeviceIdiomAppleWatch = 5,
};

#endif /* CUIDeviceIdiom_h */
