//
//  RBBlendMode.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>

RB_ASSUME_NONNULL_BEGIN

RB_EXTERN_C_BEGIN

typedef enum RBBlendMode : int32_t {
    RBBlendModeNormal = 0,
    RBBlendModeMultiply = 1,
    RBBlendModeScreen = 2,
    RBBlendModeOverlay = 3,
    RBBlendModeDarken = 4,
    RBBlendModeLighten = 5,
    RBBlendModeColorDodge = 6,
    RBBlendModeColorBurn = 7,
    RBBlendModeSoftLight = 8,
    RBBlendModeHardLight = 9,
    RBBlendModeDifference = 10,
    RBBlendModeExclusion = 11,
    RBBlendModeHue = 12,
    RBBlendModeSaturation = 13,
    RBBlendModeColor = 14,
    RBBlendModeLuminosity = 15,
    RBBlendModeClear = 16,
    RBBlendModeCopy = 17,
    RBBlendModeSourceIn = 18,
    RBBlendModeSourceOut = 19,
    RBBlendModeSourceAtop = 20,
    RBBlendModeDestinationOver = 21,
    RBBlendModeDestinationIn = 22,
    RBBlendModeDestinationOut = 23,
    RBBlendModeDestinationAtop = 24,
    RBBlendModeXOR = 25,
    RBBlendModePlusDarker = 26,
    RBBlendModePlusLighter = 27,
    RBBlendModeLinearDodge = 1000,
    RBBlendModeLinearBurn = 1001,
    RBBlendModeLinearLight = 1002,
    RBBlendModePinLight = 1003,
    RBBlendModeSubtract = 1004,
    RBBlendModeDivide = 1005,
    RBBlendModeMaximum = 1006,
    RBBlendModeAdd = 1007,
    RBBlendModeSubtractSource = 1008,
    RBBlendModeSubtractDestination = 1009,
    RBBlendModeDarkenSourceOver = 1010,
    RBBlendModeLightenSourceOver = 1011,
    RBBlendModeMinimum = 1012,
    RBBlendModeMinimumInverse = 1013,
    RBBlendModePassThrough = 2000,
} RBBlendMode;

RB_EXTERN_C_END

RB_ASSUME_NONNULL_END
