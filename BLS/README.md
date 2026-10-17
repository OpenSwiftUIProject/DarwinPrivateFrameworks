## BacklightServices

Current Xcode version: Xcode 26.6.

### update.sh

After making changes to Sources or tbds, run `update.sh` to update the xcframework.

### tbd

#### Version OS_RELEASE 2024 / 6.5.1

- iOS's tbd is from
    - `https://github.com/xybp888/iOS-SDKs/blob/master/iPhoneOS18.5.sdk/System/Library/PrivateFrameworks/BacklightServices.framework/BacklightServices.tbd`

- iOS Simulator:
    - `/Library/Developer/CoreSimulator/Volumes/iOS_22F77/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 18.5.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/BacklightServices.framework`
    - `xcrun tapi stubify --no-compact ./BacklightServices.framework`

- visionOS Simulator:
    - `/Library/Developer/CoreSimulator/Volumes/xrOS_22O473/Library/Developer/CoreSimulator/Profiles/Runtimes/xrOS 2.5.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/BacklightServices.framework`
    - `xcrun tapi stubify --no-compact ./BacklightServices.framework`
- visionOS:
    - `dyld_shared_cache_arm64e` from the visionOS 2.5 (22O473) Apple Vision Pro firmware. See [Device tbd Files](../README.md#device-tbd-files).
    - `Scripts/generate_device_tbd.sh xros <dyld_shared_cache_arm64e> BacklightServices`

#### iOS device TBD format

Use TAPI v5 for Xcode Preview parsing. Run these commands from the repository root
to convert the device stub and format the JSON:

```sh
xcrun tapi stubify --filetype=tbd-v5 \
  BLS/2024/tbds/ios-arm64-arm64e/BacklightServices.tbd \
  -o /tmp/BacklightServices-v5.tbd
python3 -m json.tool --indent 2 \
  /tmp/BacklightServices-v5.tbd \
  BLS/2024/tbds/ios-arm64-arm64e/BacklightServices.tbd
```

Alternatively, copy the formatted iOS Simulator stub:

```sh
cp BLS/2024/tbds/ios-arm64-x86_64-simulator/BacklightServices.tbd \
  BLS/2024/tbds/ios-arm64-arm64e/BacklightServices.tbd
```

Then replace `main_library.target_info` with the device targets:

```json
[
  {
    "min_deployment": "18.5",
    "target": "arm64-ios"
  },
  {
    "min_deployment": "18.5",
    "target": "arm64e-ios"
  }
]
```

The current simulator stub has 238 exported symbols; the device stub has 420.
Use this alternative only when the simulator stub contains all required symbols.

After either method, synchronize the XCFramework:

```sh
DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE=2024 bash BLS/update.sh
```

### Supported Platforms

- iOS (arm64, arm64e)
- iOS Simulator (arm64, x86_64)
- visionOS Simulator (arm64, x86_64)
- visionOS (arm64, arm64e)
