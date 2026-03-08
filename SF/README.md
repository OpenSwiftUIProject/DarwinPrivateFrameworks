## SFSymbols

### update.sh

After making changes to Sources or tbds, run `update.sh` to update the xcframework.

### tbd

#### Version OS_RELEASE 2024

- iOS's tbd is from
    - `https://github.com/xybp888/iOS-SDKs/blob/master/iPhoneOS18.0.sdk/System/Library/PrivateFrameworks/SFSymbols.framework/SFSymbols.tbd` 
- iOS Simulator:
    - `/Library/Developer/CoreSimulator/Volumes/iOS_22A3351/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 18.0.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/SFSymbols.framework`
    - `xcrun tapi stubify ./SFSymbols.framework`
- macOS:
    - `/Applications/Xcode-16.0.0.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX15.0.sdk/System/Library/PrivateFrameworks/SFSymbols.framework/SFSymbols.tbd`

### Supported Platforms

- macOS (arm64e, arm64, x86_64)
- iOS (arm64, arm64e)
- iOS Simulator (arm64, x86_64)
