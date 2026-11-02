# CoreMaterial

The header exposes material recipes, visual styles, dictionary options, and
`MTVisualStylingCreateDictionaryRepresentation`.

[CoreMaterialExample](../Example/CoreMaterialExample) displays the dictionary
returned for the selected recipe, category, style, and options. Its workflow
builds the app for iOS, iOS Simulator, macOS, visionOS, and visionOS Simulator.

## TBD Sources

Release `2024` uses the following inputs. The TBD files contain the complete
exports from each input, including symbols that the header does not yet declare.

| Slice | Input |
| --- | --- |
| `ios-arm64-arm64e` | [iOS 18.5 SDK stub](https://github.com/xybp888/iOS-SDKs/blob/4c6806ebec5353f202a8e39dafba158d52f057e4/iPhoneOS18.5.sdk/System/Library/PrivateFrameworks/CoreMaterial.framework/CoreMaterial.tbd) |
| `ios-arm64-x86_64-simulator` | CoreMaterial `202.5.1` from iOS 18.5 Simulator, build `22F77` |
| `macos-arm64e-arm64-x86_64` | CoreMaterial stub from the macOS 15.5 SDK in Xcode 16.4 |
| `xros-arm64-arm64e` | CoreMaterial `202.5.1` from the visionOS 2.5 device shared cache, build `22O473` |
| `xros-arm64-x86_64-simulator` | CoreMaterial `202.5.1` from visionOS 2.5 Simulator, build `22O473` |

The simulator inputs are the universal binaries in
`System/Library/PrivateFrameworks/CoreMaterial.framework/CoreMaterial` under
each runtime root. The SDK inputs are the original `.tbd` files under the
same framework path; the macOS framework uses `Versions/A/CoreMaterial.tbd`.

## Regenerate

Run from the repository root. For each simulator binary or SDK stub, set its
input path and destination slice, then run TAPI:

```shell
COREMATERIAL_INPUT="/path/to/CoreMaterial.framework/CoreMaterial"
COREMATERIAL_SLICE="ios-arm64-x86_64-simulator"
xcrun tapi stubify --no-compact "$COREMATERIAL_INPUT" \
  -o "CoreMaterial/2024/tbds/$COREMATERIAL_SLICE/CoreMaterial.tbd"
```

For the visionOS device slice, prepare the firmware cache as described in
[Device TBD Files](../README.md#device-tbd-files), then run:

```shell
Scripts/generate_device_tbd.sh xros "/path/to/dyld_shared_cache_arm64e" CoreMaterial
```

That script extracts the device binary and runs TAPI. Cache symbol tables can
omit the leading underscore on Objective-C ivar names, which causes TAPI to
omit those exports. The script restores missing ivar exports from the binary's
export trie, then adds the `arm64` target beside `arm64e` for application
linking. It does not derive device exports from the simulator.

The checked-in source stubs use JSON TBD v5 from TAPI 21. Preserve the generated
symbol lists. The SDK stubs can retain additional targets from their source;
the XCFramework manifest selects the supported package slices.

Rebuild the XCFramework after updating the stubs or header:

```shell
CoreMaterial/update.sh
```

`update.sh` copies the header and module map and removes `allowable_clients`
from each packaged stub so clients can link through this package. It preserves
all export groups and other TBD fields. The source files under `2024/tbds/`
retain the original client metadata.
