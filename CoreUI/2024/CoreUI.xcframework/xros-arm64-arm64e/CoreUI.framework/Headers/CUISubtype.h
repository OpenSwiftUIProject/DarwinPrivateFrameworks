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

typedef CUI_ENUM(NSUInteger, CUISubtype) {
    CUISubtypeNormal          = 0,    // iPhone <= 480pt height (iPhone 4/4S)
    CUISubtypeIPadMini        = 163,  // iPad Mini (163 points per inch)
    CUISubtypeAppleWatch38    = 320,  // Apple Watch 38mm
    CUISubtypeAppleWatch42    = 384,  // Apple Watch 42mm
    CUISubtypeIPhone4Inch     = 568,  // iPhone 5/5c/5s/SE (4-inch, 568pt height)
    CUISubtypeIPhone47Inch    = 569,  // iPhone 6/6s/7/8 (4.7-inch, 667pt height)
    CUISubtypeIPhonePlus      = 570,  // iPhone 6 Plus/6s Plus/7 Plus/8 Plus (5.5-inch, >667pt height)
    CUISubtypeAppleTVHD       = 720,  // Apple TV HD (720p)
    CUISubtypeAppleVision     = 3648, // Apple Vision Pro
};

#endif /* CUISubtype_h */
