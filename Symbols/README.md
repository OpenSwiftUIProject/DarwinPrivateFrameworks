# Symbols

The `Symbols` product provides the public Symbols API and additional state
access through `@_spi(Private) import Symbols`. It includes RenderBox because
the private interface uses `RBSymbolAnimation` and its option keys.

```swift
@_spi(Private) import Symbols

let configuration = BounceSymbolEffect.bounce.up.configuration
if case let .bounce(effect) = configuration.effect {
    print(effect.isUp as Any)
}
```

Ordinary `import Symbols` retains the SDK public API. The private interface
adds the configuration's `Effect` enum, effect state properties, the nested
style and repeat enums, `MagicReplaceSymbolEffect`, and RenderBox conversion
accessors. These declarations use the native Symbols type identities and
system implementation. `Private` is the SPI group used by this package.

## Sources

Release 2024 uses Symbols `167.5.0.2` from the Xcode 16.4 SDKs: iOS 18.5,
macOS 15.5, and visionOS 2.5. Public headers and Swift interface bodies are
identical across these SDKs. The public template preserves the SDK declarations
and availability attributes. Trailing whitespace is removed from copied inputs.
The private template contains only the additions.

The five `tbds/` files come from each platform's public SDK Symbols framework.
They retain the SDK exports and install names; only trailing whitespace is
removed. No framework binary is included.

## Update

Edit `2024/Sources/Modules/Symbols.swiftmodule/template.private.swiftinterface`
for SPI changes, then run from the repository root:

```sh
Scripts/update_frameworks.sh Symbols
```

The command plugin also runs this update. The script generates matching public
and private interfaces for every architecture from the checked-in sources;
generation does not require an installed SDK.

To refresh SDK inputs, copy the headers and module map from
`System/Library/Frameworks/Symbols.framework`. Copy a public Swift interface
from its `Modules/Symbols.swiftmodule` directory into `template.swiftinterface`
after removing the `// swift-` header lines. Verify that the interface body and
headers agree across platforms. Copy each SDK's `Symbols.tbd` to its matching
slice directory and update the compiler/module version in `update.sh`.

## Supported Slices

- macOS: arm64, arm64e, x86_64.
- iOS: arm64, arm64e.
- iOS Simulator: arm64, x86_64.
- visionOS: arm64, arm64e.
- visionOS Simulator: arm64, x86_64.

The generated interfaces target the release 2024 deployment versions. Runtime
validation uses iOS 18.5; older system versions need separate validation.
