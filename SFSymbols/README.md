## SFSymbols

### update.sh

After making changes to Sources or tbds, run `update.sh` to update the xcframework.

### tbd

#### Version OS_RELEASE 2024

- iOS:
    - copy from ios-arm64-x86_64-simulator
- iOS Simulator:
    - `/Library/Developer/CoreSimulator/Volumes/iOS_22F77/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 18.5.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/SFSymbols.framework`
    - `xcrun tapi stubify ./SFSymbols.framework`
- macOS's tbd is from macOS 15.5 SDK (bundled with Xcode 16.4)
    - `/Applications/Xcode-16.4.0.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX15.5.sdk/System/Library/PrivateFrameworks/SFSymbols.framework/Versions/A/SFSymbols.tbd`

### Supported Platforms

- macOS (arm64e, arm64, x86_64)
- iOS (arm64, arm64e)
- iOS Simulator (arm64, x86_64)
