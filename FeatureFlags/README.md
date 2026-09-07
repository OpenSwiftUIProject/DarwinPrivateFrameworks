# FeatureFlags

Swift declarations and linker stubs for the system FeatureFlags framework.
The xcframework contains no replacement implementation. Consumers link to the
system framework through its absolute install name.

## API

```swift
import FeatureFlags

struct GestureContainerKey: FeatureFlagsKey {
    var domain: StaticString { "SwiftUI" }
    var feature: StaticString { "gestureContainer" }
}

let enabled = isFeatureEnabled(GestureContainerKey())
```

Add the `FeatureFlags` product from `DarwinPrivateFrameworks` to the consumer
SwiftPM target. Keep the system domain and feature names when querying a system
flag.

## Sources

- macOS stub: macOS 15.5 SDK in Xcode 16.4, FeatureFlags version 97.
- Simulator stub: `tapi stubify` output from the iOS 18.5 Simulator runtime,
  FeatureFlags version 97.
- Device stub: the simulator export list with arm64/arm64e iOS targets, following
  the existing SFSymbols device stub pattern. SwiftUICore 6.5.4 imports the same
  protocol and function symbols.
- Swift declarations: protocol requirements and function signature recovered
  from these exports and SwiftUICore 6.5.4 conformances.

## Supported platforms

- macOS 15.0: arm64, arm64e, x86_64.
- iOS 18.0: arm64, arm64e.
- iOS Simulator 18.5: arm64, x86_64.

Mac Catalyst, tvOS, watchOS, and visionOS slices are not included.

## Update

After editing `2024/Sources` or `2024/tbds`, run:

```shell
./FeatureFlags/update.sh
```

The update plugin and `Scripts/update_frameworks.sh all` also regenerate this
framework.
