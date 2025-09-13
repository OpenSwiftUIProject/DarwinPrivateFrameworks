---
name: generate-tbd
description: Generate TBD files for frameworks from any platform runtime
---

Generate TBD files for the specified frameworks from the given platform runtime location.

## Usage

This command will:
1. Copy each framework from the platform runtime to a temporary location
2. Generate TBD files using `xcrun tapi stubify`
3. Copy TBD and Info.plist files to the appropriate directories
4. Convert Info.plist files to XML format
5. Update the generation scripts (update.sh) to include platform support
6. Update README files with platform-specific instructions

## Parameters

When using this command, provide:
- **Platform**: The platform to generate TBDs for (ios, xros, macos, tvos, watchos)
- **Runtime path**: The path to the simulator runtime (e.g., `/Library/Developer/CoreSimulator/Volumes/xrOS_22O473/Library/Developer/CoreSimulator/Profiles/Runtimes/xrOS 2.5.simruntime`)
- **Frameworks**: List of frameworks to process (e.g., AttributeGraph, RenderBox, CoreUI)

## Examples

### visionOS
```
/generate-tbd

Platform: xros
Runtime: /Library/Developer/CoreSimulator/Volumes/xrOS_22O473/Library/Developer/CoreSimulator/Profiles/Runtimes/xrOS 2.5.simruntime
Frameworks: AttributeGraph RenderBox CoreUI
```

### iOS
```
/generate-tbd

Platform: ios  
Runtime: /Library/Developer/CoreSimulator/Volumes/iOS_22F77/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 18.5.simruntime
Frameworks: AttributeGraph RenderBox CoreUI
```

## Implementation

The command will execute the script at `Scripts/generate_tbd.sh` with the provided parameters. The script will:

1. For each framework:
   - Copy from `{runtime}/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/{framework}.framework`
   - Generate TBD using `xcrun tapi stubify`
   - Create directory structure based on platform:
     - iOS: `{framework_dir}/2024/tbds/ios-arm64-x86_64-simulator/`
     - visionOS: `{framework_dir}/2024/tbds/xros-arm64-x86_64-simulator/`
     - macOS: `{framework_dir}/2024/tbds/macos-arm64e-arm64-x86_64/`
     - tvOS: `{framework_dir}/2024/tbds/tvos-arm64-x86_64-simulator/`
     - watchOS: `{framework_dir}/2024/tbds/watchos-arm64-x86_64-simulator/`
   - Copy and convert Info.plist to XML format

2. Update each framework's `update.sh` script to add platform support:
   ```bash
   # Add {platform} support if available
   if [ -d "${FRAMEWORK_ROOT}/tbds/{platform-dir}" ]; then
       generate_framework $framework_name {platform-dir}
   fi
   ```

3. Update each framework's README.md with platform-specific instructions

## Platform Directory Mappings

- **ios**: ios-arm64-x86_64-simulator
- **xros**: xros-arm64-x86_64-simulator  
- **macos**: macos-arm64e-arm64-x86_64
- **tvos**: tvos-arm64-x86_64-simulator
- **watchos**: watchos-arm64-x86_64-simulator

## Framework Directory Mappings

- **AttributeGraph**: AG
- **RenderBox**: RB
- **CoreUI**: CoreUI

## Notes

- Info.plist files are converted to XML format using `plutil -convert xml1`
- The script includes error checking for missing directories and existing platform support
- For AttributeGraph with visionOS, additional manual configuration may be needed for swiftinterface generation