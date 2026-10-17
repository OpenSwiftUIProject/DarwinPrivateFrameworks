//
//  RBColorMode.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>
#include <RenderBox/RBColorSpace.h>

RB_ASSUME_NONNULL_BEGIN

RB_EXTERN_C_BEGIN

typedef int32_t RBColorMode RB_SWIFT_STRUCT RB_SWIFT_NAME(RBColor.Mode);

RB_EXPORT RBColorSpace RBColorModeWorkingColorSpace(RBColorMode mode) RB_SWIFT_NAME(getter:RBColorMode.workingColorSpace(self:));
RB_EXPORT bool RBColorModeHasExtendedRange(RBColorMode mode) RB_SWIFT_NAME(getter:RBColorMode.hasExtendedRange(self:));

RB_EXTERN_C_END

RB_ASSUME_NONNULL_END

