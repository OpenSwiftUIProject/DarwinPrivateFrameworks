//
//  RBColor.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>

RB_ASSUME_NONNULL_BEGIN

RB_EXTERN_C_BEGIN

typedef struct RBColor {
    float red;
    float green;
    float blue;
    float alpha;
} RBColor;

RB_EXTERN_C_END

RB_ASSUME_NONNULL_END

