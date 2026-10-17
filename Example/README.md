# Example

Example apps demonstrating usage of DarwinPrivateFrameworks.

## Prerequisites

Install [mise](https://mise.jdx.dev/) to manage the Tuist version:

```bash
brew install mise
```

## Setup

```bash
cd Example

# Install pinned Tuist version
mise install

# Resolve external dependencies
tuist install

# Generate Xcode project
tuist generate
```

This generates `Example.xcworkspace` — open it in Xcode to build and run the example targets.

## Targets

| Target | Framework | Platforms |
|--------|-----------|-----------|
| AGExample | AttributeGraph | iOS, macOS, visionOS |
| RBExample | RenderBox | iOS, macOS, visionOS |
| CoreUIExample | CoreUI | iOS, macOS, visionOS |
| CoreSVGExample | CoreSVG | iOS, macOS, visionOS |
| BLSExample | BacklightServices | iOS, visionOS |
| SFSymbolsExample | SFSymbols | iOS, macOS, visionOS |
| GFExample | Gestures | iOS, macOS |
| FeatureFlagsExample | FeatureFlags | iOS, macOS, visionOS |

`FeatureFlagsExample` queries the system `SwiftUI.gestureContainer` flag and
displays its enabled state. Use Refresh to query the flag again.

## Regenerating

After modifying `Project.swift` or updating dependencies, re-run:

```bash
tuist install
tuist generate
```
