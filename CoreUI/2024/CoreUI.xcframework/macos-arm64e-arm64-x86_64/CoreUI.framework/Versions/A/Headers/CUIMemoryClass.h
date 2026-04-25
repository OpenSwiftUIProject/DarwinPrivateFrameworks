//
//  CUIMemoryClass.h
//  CoreUI
//
//  Audited for 918.3
//  Status: Complete

#ifndef CUIMemoryClass_h
#define CUIMemoryClass_h

#import <Foundation/Foundation.h>
#import <CoreUI/CUIBase.h>

typedef CUI_CLOSED_ENUM(NSInteger, CUIMemoryClass) {
    CUIMemoryClassDefault  = 0,
    CUIMemoryClassMemory1GB = 1,
    CUIMemoryClassMemory2GB = 2,
    CUIMemoryClassMemory4GB = 3,
};

#endif /* CUIMemoryClass_h */
