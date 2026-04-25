//
//  RBColorSpace.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>

RB_ASSUME_NONNULL_BEGIN

RB_EXTERN_C_BEGIN

typedef RB_ENUM(uint32_t, RBColorSpace) {
    RBColorSpaceDefault = 0,
    RBColorSpaceSRGB = 1,
    RBColorSpaceLinearSRGB = 2,
    RBColorSpaceDisplayP3 = 3,
    RBColorSpaceLinearDisplayP3 = 4,
} RB_SWIFT_NAME(RBColor.ColorSpace);

RB_EXTERN_C_END

RB_ASSUME_NONNULL_END

