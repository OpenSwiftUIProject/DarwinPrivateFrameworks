---
name: create_private_framework
description: Claude Command to Create Private SDK XCFramework
---

To create a new private SDK xcframework like BacklightServices, follow these steps:

## Command Summary

```bash
# 1. Create directory structure
mkdir -p <FrameworkName>/{2024/{Sources,tbds},latest}
cd <FrameworkName>

# 2. Create tbd subdirectories for each platform
mkdir -p 2024/tbds/{ios-arm64-arm64e,ios-arm64-x86_64-simulator,xros-arm64-x86_64-simulator}

# 3. Extract tbd files from simulators
# For iOS Simulator
cp -r "/Library/Developer/CoreSimulator/Volumes/iOS_22F77/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 18.5.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/<FrameworkName>.framework" /tmp/<FrameworkName>_ios_simulator.framework
cd /tmp && xcrun tapi stubify ./<FrameworkName>_ios_simulator.framework
cp /tmp/<FrameworkName>_ios_simulator.framework/<FrameworkName>.tbd <path>/2024/tbds/ios-arm64-x86_64-simulator/

# For visionOS Simulator
cp -r "/Library/Developer/CoreSimulator/Volumes/xrOS_22O473/Library/Developer/CoreSimulator/Profiles/Runtimes/xrOS 2.5.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/<FrameworkName>.framework" /tmp/<FrameworkName>_xros_simulator.framework
cd /tmp && xcrun tapi stubify ./<FrameworkName>_xros_simulator.framework
cp /tmp/<FrameworkName>_xros_simulator.framework/<FrameworkName>.tbd <path>/2024/tbds/xros-arm64-x86_64-simulator/

# 4. Get iOS device tbd from GitHub
curl -s "https://raw.githubusercontent.com/xybp888/iOS-SDKs/master/iPhoneOS18.5.sdk/System/Library/PrivateFrameworks/<FrameworkName>.framework/<FrameworkName>.tbd" > 2024/tbds/ios-arm64-arm64e/<FrameworkName>.tbd

# 5. Set up framework-specific files
# For Swift frameworks:
mkdir -p 2024/Sources/Modules/<FrameworkName>.swiftmodule
# Create template.swiftinterface with Swift module declarations

# For Objective-C frameworks:
mkdir -p 2024/Sources/{Headers,Modules}
# Extract headers using ipsw class-dump (creates individual header files in a subdirectory)
ipsw class-dump "/Library/Developer/CoreSimulator/Volumes/iOS_22F77/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 18.5.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/<FrameworkName>.framework/<FrameworkName>" --headers --arch arm64 -o 2024/Sources/Headers
# This creates a <FrameworkName>/ subdirectory in Headers/ with all the header files
# Note: Headers are universal and can be used for all platforms (iOS, iOS Simulator, visionOS Simulator)
# Create module.modulemap in Modules/

# 6. Create Info.plist for xcframework

# 7. Create update.sh script

# 8. Run update.sh to generate xcframework
./update.sh

# 9. Create symlink to latest version
ln -s ./2024 latest
```

## Key Files Created

1. **Info.plist** - Defines the xcframework structure with library identifiers for each platform
2. **update.sh** - Script to regenerate the xcframework from tbd files
3. **README.md** - Documentation for the framework
4. **tbds/** - Directory containing .tbd stub files for each platform:
   - ios-arm64-arm64e (iPhone device)
   - ios-arm64-x86_64-simulator (iPhone Simulator)
   - xros-arm64-x86_64-simulator (visionOS Simulator)
5. **For Swift frameworks:**
   - `Sources/Modules/<FrameworkName>.swiftmodule/template.swiftinterface` - Template for Swift interface generation
6. **For Objective-C frameworks:**
   - `Sources/Headers/` - Directory containing framework header files
   - `Sources/Modules/module.modulemap` - Module map defining the framework's module structure

## Platform Support

The framework supports:
- iOS Device (arm64, arm64e)
- iOS Simulator (arm64, x86_64)
- visionOS Simulator (arm64, x86_64)

## Notes

- The `xcrun tapi stubify` command is used to generate .tbd files from framework binaries
- The 2024 version corresponds to iOS 18.5, macOS 15.5, and visionOS 2.5
- Always create a symlink named `latest` pointing to the current version directory
- **Swift frameworks** require a `template.swiftinterface` file for proper module interface generation (see AttributeGraph for example)
- **Objective-C frameworks** require a `module.modulemap` and header files in the Sources directory
- The `update.sh` script should handle copying these files into the generated xcframework structure

---

Create framework: $ARGUMENTS
