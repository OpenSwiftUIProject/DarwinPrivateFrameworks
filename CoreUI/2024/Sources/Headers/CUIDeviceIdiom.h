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

typedef CUI_ENUM(NSInteger, CUIDeviceIdiom) {
    CUIDeviceIdiomUniversal  = 0, // Universal (any device)
    CUIDeviceIdiomIPhone     = 1, // iPhone
    CUIDeviceIdiomIPad       = 2, // iPad
    CUIDeviceIdiomAppleTV    = 3, // Apple TV
    CUIDeviceIdiomCarPlay    = 4, // CarPlay
    CUIDeviceIdiomAppleWatch = 5, // Apple Watch
    CUIDeviceIdiomMarketing  = 6, // Marketing (used for marketing assets)
    CUIDeviceIdiomMac        = 7, // Mac (Catalyst apps)
    CUIDeviceIdiomVision     = 8, // Apple Vision Pro
};

#endif /* CUIDeviceIdiom_h */
