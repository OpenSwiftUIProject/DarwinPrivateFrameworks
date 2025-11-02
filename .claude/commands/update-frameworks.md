---
name: update-frameworks
description: Update xcframeworks by running update.sh scripts for specified frameworks
---

Run the update.sh script for specified frameworks to regenerate their xcframework structures.

## Usage

This command will execute the `update.sh` script in each specified framework directory to:
1. Generate the xcframework structure
2. Copy TBD files to the framework bundles
3. Copy headers and modules
4. Update version information in headers (where applicable)
5. Generate Swift interfaces for supported platforms (AttributeGraph only)

## Parameters

When using this command, provide:
- **Frameworks**: List of frameworks to update (e.g., AttributeGraph, RenderBox, CoreUI, or "all" for all frameworks)
- **Version** (optional): Target release version (2021 or 2024, defaults to 2024)

## Examples

### Update specific frameworks
```
/update-frameworks

Frameworks: AttributeGraph RenderBox CoreUI
Version: 2024
```

### Update all frameworks
```
/update-frameworks

Frameworks: all
```

### Update with specific version
```
/update-frameworks

Frameworks: AttributeGraph
Version: 2021
```

## Implementation

The command will:

1. For each specified framework:
   - Navigate to the framework directory (AG, RB, or CoreUI)
   - Set the `DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE` environment variable if version is specified
   - Execute the `update.sh` script
   - Report success or failure

2. If "all" is specified, it will update:
   - AttributeGraph (AG)
   - RenderBox (RB)
   - CoreUI

## Framework Directory Mappings

- **AttributeGraph**: AG/update.sh
- **RenderBox**: RB/update.sh
- **CoreUI**: CoreUI/update.sh

## What each update.sh does

### AttributeGraph (AG)
- Generates xcframework structure
- Updates AGVersion.h with release version
- Supports iOS, macOS, and visionOS (if TBDs exist)

### RenderBox (RB)
- Generates xcframework structure
- Updates RBVersion.h with release version
- Supports iOS, macOS, and visionOS (if TBDs exist)

### CoreUI
- Generates xcframework structure
- Supports iOS, macOS, and visionOS (if TBDs exist)

## Notes

- The scripts use the `DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE` environment variable to determine the version (defaults to 2024)
- Make sure TBD files exist in the appropriate directories before running update

## Prerequisites

Before running this command, ensure:
1. TBD files are present in the `{framework}/2024/tbds/` directories
2. Source headers and modules are present in `{framework}/2024/Sources/`
3. Info.plist files are optional for each platform