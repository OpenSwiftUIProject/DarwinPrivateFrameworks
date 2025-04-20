//
//  CUIColorName.h
//  CoreUI
//
//  Audited for macOS 15.0
//  Status: WIP

#ifndef CUIColorName_h
#define CUIColorName_h

#import <CoreUI/CUIBase.h>
#import <CoreFoundation/CoreFoundation.h>

// TODO: 29 cases
typedef CUI_CLOSED_ENUM(NSUInteger, CUIColorName) {
    CUIColorNameRed = 0,
    CUIColorNameOrange = 1,
    CUIColorNameYellow = 2,
    CUIColorNameGreen = 3,
    CUIColorNameTeal = 4,
    CUIColorNameMint = 5,
    CUIColorNameCyan = 6,
    CUIColorNameBlue = 7,
    CUIColorNameIndigo = 8,
    CUIColorNamePurple = 9,
    CUIColorNamePink = 10,
    CUIColorNameGray = 13,
    CUIColorNameBrown = 14,
    CUIColorNamePrimary = 15,
    CUIColorNameSecondary = 16,
    CUIColorNameTertiary = 17,
    CUIColorNameQuaternary = 18,
    CUIColorNameQuinary = 19
};

#endif /* CUIColorName_h */
