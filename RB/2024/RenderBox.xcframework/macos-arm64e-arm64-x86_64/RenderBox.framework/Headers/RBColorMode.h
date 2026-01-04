//
//  RBColorMode.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>
#include <RenderBox/RBColorSpace.h>

RB_ASSUME_NONNULL_BEGIN

RB_EXTERN_C_BEGIN

typedef RB_ENUM(uint32_t, RBColorMode) {
    RBColorMode0 = 0,
    RBColorMode1 = 1,
    RBColorMode2 = 2,
    RBColorMode3 = 3,
    RBColorMode4 = 4,
    RBColorMode5 = 5,
    RBColorMode6 = 6,
    RBColorMode7 = 7,
    RBColorMode8 = 8,
    RBColorMode9 = 9,
    RBColorMode10 = 10,
    RBColorMode11 = 11,
    RBColorMode12 = 12,
    RBColorMode13 = 13,
    RBColorMode14 = 14,
    RBColorMode15 = 15,
} RB_SWIFT_NAME(RBColor.Mode);

RB_EXPORT RBColorSpace RBColorModeWorkingColorSpace(RBColorMode mode) RB_SWIFT_NAME(getter:RBColorMode.workingColorSpace(self:));
RB_EXPORT bool RBColorModeHasExtendedRange(RBColorMode mode) RB_SWIFT_NAME(getter:RBColorMode.hasExtendedRange(self:));

RB_EXTERN_C_END

RB_ASSUME_NONNULL_END

