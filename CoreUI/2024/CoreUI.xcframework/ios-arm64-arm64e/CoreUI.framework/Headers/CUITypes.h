//
//  CUITypes.h
//  CoreUI
//
//  Audited for 918.3
//  Status: Complete

#ifndef CUITypes_h
#define CUITypes_h

#import <CoreUI/CUIDeviceIdiom.h>
#import <CoreUI/CUISubtype.h>
#import <CoreUI/CUIUserInterfaceSizeClass.h>
#import <CoreUI/CUIRenderMode.h>
#import <CoreUI/CUIResizingMode.h>
#import <CoreUI/CUIImageType.h>
#import <CoreUI/CUIGraphicalClass.h>
#import <CoreUI/CUILayoutDirection.h>
#import <CoreUI/CUIMemoryClass.h>

#import <CoreGraphics/CoreGraphics.h>

typedef struct CUIEdgeInsets {
    CGFloat top;
    CGFloat left;
    CGFloat bottom;
    CGFloat right;
} CUIEdgeInsets;

#endif /* CUITypes_h */
