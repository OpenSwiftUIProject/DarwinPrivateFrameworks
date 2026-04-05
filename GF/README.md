## Gestures

### update.sh

After making change to Sources, run `update.sh` to update the xcframework.

### tbd

#### Version 2025

- iOS Simulator:
    - `/Library/Developer/CoreSimulator/Volumes/iOS_26B5024g/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 26.2.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/Gestures.framework`
    - `xcrun tapi stubify ./Gestures.framework`

- macOS's tbd is from macOS 26.2 SDK (bundled with Xcode 26.3)
    - `/Applications/Xcode-26.3.0.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX26.2.sdk/System/Library/PrivateFrameworks/Gestures.framework/Gestures.tbd`
