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
| AGExample_2021 | AttributeGraph (2021) | iOS, macOS |
| AGExample_2024 | AttributeGraph (2024) | iOS, macOS, visionOS |
| RBExample_2024 | RenderBox | iOS, macOS, visionOS |
| CoreUIExample_2024 | CoreUI | iOS, macOS, visionOS |
| BLSExample_2024 | BacklightServices | iOS, visionOS |
| SFSymbolsExample_2024 | SFSymbols | iOS, macOS |

## Regenerating

After modifying `Project.swift` or updating dependencies, re-run:

```bash
tuist install
tuist generate
```
