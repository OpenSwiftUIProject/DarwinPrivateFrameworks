## CoreSVG

### tbd

#### Version OS_RELEASE 2024

- iOS's tbd is derived from iOS Simulator tbd (targets changed to arm64-ios/arm64e-ios)
- iOS Simulator:
    - `/Library/Developer/CoreSimulator/Volumes/iOS_22F77/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 18.5.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/CoreSVG.framework`
    - `xcrun tapi stubify --no-compact ./CoreSVG.framework`
- macOS's tbd is from macOS 15.5 SDK (bundled with Xcode 16.4)
- visionOS Simulator:
    - `/Library/Developer/CoreSimulator/Volumes/xrOS_22O473/Library/Developer/CoreSimulator/Profiles/Runtimes/xrOS 2.5.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/CoreSVG.framework`
    - `xcrun tapi stubify --no-compact ./CoreSVG.framework`
