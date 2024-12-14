## RenderBox

### update.sh

After making change to Sources, run `update.sh` to update the xcframework.

### tbd

#### Version OS_RELEASE 2024

- iOS's tbd is from
    - `https://github.com/xybp888/iOS-SDKs/blob/master/iPhoneOS18.0.sdk/System/Library/PrivateFrameworks/RenderBox.framework/RenderBox.tbd` 
- iOS Simulator: 
    - `/Library/Developer/CoreSimulator/Volumes/iOS_22A3351/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 18.0.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/RenderBox.framework`
    - `xcrun tapi stubify ./RenderBox.framework`

- macOS's tbd is from macOS 15.0 SDK (bundled with Xcode 16.0)
    - `/Applications/Xcode-16.0.0.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX15.0.sdk/System/Library/PrivateFrameworks/RenderBox.framework`
    - `xcrun tapi stubify ./RenderBox.framework`

