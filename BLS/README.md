## BacklightServices

### update.sh

After making changes to Sources or tbds, run `update.sh` to update the xcframework.

### tbd

#### Version OS_RELEASE 2024 / 6.5.1

- iOS's tbd is from
    - `https://github.com/xybp888/iOS-SDKs/blob/master/iPhoneOS18.5.sdk/System/Library/PrivateFrameworks/BacklightServices.framework/BacklightServices.tbd`

- iOS Simulator:
    - `/Library/Developer/CoreSimulator/Volumes/iOS_22F77/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 18.5.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/BacklightServices.framework`
    - `xcrun tapi stubify ./BacklightServices.framework`

- visionOS Simulator:
    - `/Library/Developer/CoreSimulator/Volumes/xrOS_22O473/Library/Developer/CoreSimulator/Profiles/Runtimes/xrOS 2.5.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/BacklightServices.framework`
    - `xcrun tapi stubify ./BacklightServices.framework`

### Supported Platforms

- iOS (arm64, arm64e)
- iOS Simulator (arm64, x86_64)
- visionOS Simulator (arm64, x86_64)
