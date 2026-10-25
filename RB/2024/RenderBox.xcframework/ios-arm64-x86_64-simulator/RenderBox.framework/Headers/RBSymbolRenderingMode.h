//
//  RBSymbolRenderingMode.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>

typedef RB_ENUM(uint32_t, RBSymbolRenderingMode) {
    RBSymbolRenderingModePreferred = 0,
    RBSymbolRenderingModeMonochrome = 1,
    RBSymbolRenderingModeMulticolor = 2,
    RBSymbolRenderingModeHierarchical = 3,
    RBSymbolRenderingModePalette = 4,
    RBSymbolRenderingModeHierarchicalUnlessSlashed = 128,
    RBSymbolRenderingModeHierarchicalSlashBadge = 129,
    RBSymbolRenderingModePaletteSlashBadge = 130,
    // No explicit mode. A symbol update keeps the animator's current mode.
    RBSymbolRenderingModeUnspecified = 255,
};
