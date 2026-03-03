## SFSymbols

### update.sh

After making changes to Sources or tbds, run `update.sh` to update the xcframework.

### tbd

#### Version OS_RELEASE 2024

- iOS Simulator:
    - `/Library/Developer/CoreSimulator/Volumes/iOS_23C54/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 26.2.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/SFSymbols.framework`
    - `xcrun tapi stubify ./SFSymbols.framework`

- iOS Device:
    - `~/Library/Developer/Xcode/iOS DeviceSupport/<device> <os-version>/Symbols/System/Library/PrivateFrameworks/SFSymbols.framework`
    - If direct stubification provides insufficient symbols, derive from simulator tbd and update `target_info` to iOS device targets.

- macOS:
    - `/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/PrivateFrameworks/SFSymbols.framework/SFSymbols.tbd`

### Supported Platforms

- macOS (arm64e, arm64, x86_64)
- iOS (arm64, arm64e)
- iOS Simulator (arm64)
