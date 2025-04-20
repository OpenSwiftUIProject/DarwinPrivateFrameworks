## CoreUI

### header

Sync from [CoreUI](https://github.com/XFrameworks/CoreUI) upstream repo.

### tbd

#### Version OS_RELEASE 2024

- iOS's tbd is from
    - `https://github.com/xybp888/iOS-SDKs/blob/master/iPhoneOS18.0.sdk/System/Library/PrivateFrameworks/CoreUI.framework/CoreUI.tbd` 
- iOS Simulator: 
    - `/Library/Developer/CoreSimulator/Volumes/iOS_22A3351/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS\ 18.0.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/CoreUI.framework`
    - `xcrun tapi stubify ./CoreUI.framework`
- macOS's tbd is from macOS 15.0 SDK (bundled with Xcode 16.0)