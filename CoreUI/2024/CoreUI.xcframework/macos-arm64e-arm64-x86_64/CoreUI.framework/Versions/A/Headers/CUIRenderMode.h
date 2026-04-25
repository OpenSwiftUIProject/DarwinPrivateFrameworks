//
//  CUIRenderMode.h
//  CoreUI
//
//  Audited for 918.3
//  Status: Complete

#ifndef CUIRenderMode_h
#define CUIRenderMode_h

#import <Foundation/Foundation.h>
#import <CoreUI/CUIBase.h>

typedef CUI_CLOSED_ENUM(NSInteger, CUIRenderMode) {
    CUIRenderModeOriginal = 0,
    CUIRenderModeTemplate = 1,
    CUIRenderModeDefault  = 2,
};

#endif /* CUIRenderMode_h */
