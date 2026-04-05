# DarwinPrivateFrameworks

| **CI Status** |
|---|
|[![AGExample](https://github.com/OpenSwiftUIProject/DarwinPrivateFrameworks/actions/workflows/ag_example.yml/badge.svg)](https://github.com/OpenSwiftUIProject/DarwinPrivateFrameworks/actions/workflows/ag_example.yml)|
|[![RBExample](https://github.com/OpenSwiftUIProject/DarwinPrivateFrameworks/actions/workflows/rb_example.yml/badge.svg)](https://github.com/OpenSwiftUIProject/DarwinPrivateFrameworks/actions/workflows/rb_example.yml)|
|[![CoreUIExample](https://github.com/OpenSwiftUIProject/DarwinPrivateFrameworks/actions/workflows/coreui_example.yml/badge.svg)](https://github.com/OpenSwiftUIProject/DarwinPrivateFrameworks/actions/workflows/coreui_example.yml)|
|[![BLSExample](https://github.com/OpenSwiftUIProject/DarwinPrivateFrameworks/actions/workflows/bls_example.yml/badge.svg)](https://github.com/OpenSwiftUIProject/DarwinPrivateFrameworks/actions/workflows/bls_example.yml)|
|[![GFExample](https://github.com/OpenSwiftUIProject/DarwinPrivateFrameworks/actions/workflows/gf_example.yml/badge.svg)](https://github.com/OpenSwiftUIProject/DarwinPrivateFrameworks/actions/workflows/gf_example.yml)|
|[![SFSymbolsExample](https://github.com/OpenSwiftUIProject/DarwinPrivateFrameworks/actions/workflows/sfsymbols_example.yml/badge.svg)](https://github.com/OpenSwiftUIProject/DarwinPrivateFrameworks/actions/workflows/sfsymbols_example.yml)|

This project contains private frameworks for Darwin platforms, including `AttributeGraph`, `RenderBox`, `CoreUI`, `BacklightServices`, `Gestures`, and `SFSymbols`.

The frameworks are provided as xcframeworks available for macOS, iOS Simulator, iOS[^1], and visionOS Simulator platforms.

> [!CAUTION]
> These private frameworks are **ONLY** for research and educational purposes.
>
> **DO NOT** use them in App Store submissions or ship them to production/release environments.
>
> Using private frameworks in App Store apps will result in rejection and will crash your app in future OS update.

> [!WARNING]
> The scripts and xcframework code have only been tested on **macOS 15.5 and iOS 18.5**. Other system versions are not guaranteed to work.
>
> Please resolve any compatibility issues yourself. Contributions are welcome!

## Structure

- `AG/`: Contains the `AttributeGraph` framework.
- `CoreUI/`: Contains the `CoreUI` framework.
- `BLS/`: Contains the `BacklightServices` framework.
- `Examples/`: Contains example projects demonstrating usage of the private frameworks.
- `GF/`: Contains the `Gestures` framework.
- `RB/`: Contains the `RenderBox` framework.
- `SF/`: Contains the `SFSymbols` framework.
- `Plugins/UpdateModule/`: Contains the `UpdateModule` plugin for updating the frameworks.

## Update

After editing the sources, you need to update the xcframeworks to reflect the changes.

To update the xcframework, run the following commands:

```shell
swift package update-xcframeworks --allow-writing-to-package-directory
```

## Usage

> [!NOTE]
> If you are using [Tuist](https://tuist.dev), version **4.168.0** or later is required for `.tbd` stub file support in xcframeworks. See [tuist/tuist#9992](https://github.com/tuist/tuist/pull/9992) for details.

There are three ways supported to integrate and use these private frameworks:

### 1. For Swift Package Manager Projects

For Swift Package Manager projects, add the dependency as a normal package dependency in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/OpenSwiftUIProject/DarwinPrivateFrameworks.git", from: "0.0.2"),
]
```

Then import and use the frameworks directly in your Swift code.

### 2. For Xcode Project

For Xcode projects, first add the dependency as above and then manually drag the corresponding xcframework into your project:

1. Locate the xcframework (e.g., `AG/2024/AttributeGraph.xcframework`)
2. Drag it into your Xcode project's target Frameworks section

> Alternatively, you could copy the corresponding AG binary directly into the framework directory of this repository to avoid manully xcframework adding.
>
> However, for maintainability and file size considerations, this approach is not currently used.
>
> In the future, once the project is stable, we may consider publishing a complete xcframework on GitHub for direct dependency.

### 3. Globally use via Internal SDK

1. Use the following installation script to set up an internal SDK to use these private frameworks[^2] globally:

```shell
# For macOS
Scripts/SDK/install_internal_sdk.sh MacOSX

# For iOS Simulator
Scripts/SDK/install_internal_sdk.sh iPhoneSimulator

# For iOS Device
Scripts/SDK/install_internal_sdk.sh iPhoneOS

# For visionOS Simulator
Scripts/SDK/install_internal_sdk.sh XRSimulator
```

2. Choose the corresponding Internal SDK as the Base SDK in your Xcode project settings.

![](Screenshots/base_sdk.png)

> **SDK Selection Guidelines:**
>
> - **Xcode < 16.3**: You can use the auto-detected "Internal SDK" (eg. macOS Internal SDK which corresponds to `macosx.internal`), or manually enter the full canonical name (e.g. `macosx15.5.internal`).
> - **Xcode ≥ 16.3**: You must use the full canonical name for all platforms due to Xcode's stricter SDK detection:
>
> For example:
> - macOS: `macosx15.5.internal`
> - iOS Simulator: `iphonesimulator18.5.internal`
> - iOS Device: `iphoneos18.5.internal`
> - visionOS Simulator: `xrsimulator2.0.internal`
>
> To get the current supported canonical name, you can run `xcodebuild -showsdks` after installing the SDK.
>
> **Note**: Command-line `xcodebuild` with `-sdk macosx.internal` works regardless of Xcode version.
>
> Similar report: https://github.com/insidegui/researchsdk/commit/71259b0a0e8c92ba31131acbe024096fbe096844

3. In your target's General tab, add the corresponding private framework shown in Apple SDKs part to the "Frameworks, Libraries, and Embedded Content" section.

![](Screenshots/add_framework.png)

4. In your Swift code, import the frameworks as needed:

```swift
import AttributeGraph
```

![](Screenshots/import_framework.png)

[^1]: The Swift API of AttributeGraph is not available on iOS platform.

[^2]: The installer currently includes AttributeGraph, RenderBox, CoreUI, BacklightServices, SFSymbols, and Gestures (platform-dependent). For visionOS, the script also enables UIScreen support by removing API availability restrictions.
