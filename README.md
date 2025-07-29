# DarwinPrivateFrameworks

This project contains private frameworks for Darwin platforms, including `AttributeGraph` and `RenderBox`.

## Structure

- `AG/`: Contains the `AttributeGraph` framework.
- `RB/`: Contains the `RenderBox` framework.
- `Plugins/UpdateModule/`: Contains the `UpdateModule` plugin for updating the frameworks.

## Usage

To integrate the frameworks, add the dependency using Swift Package Manager as usual.  
When using the frameworks in your project, you need to drag the corresponding xcframework (e.g., `AG/2024/AttributeGraph.xcframework`) into your Xcode project's target Frameworks section.

Alternatively, you could copy the corresponding AG binary directly into the framework directory of this repository. However, for maintainability and file size considerations, this approach is not currently used. In the future, once the project is stable, we may consider publishing a complete xcframework on GitHub for direct dependency.

## Update

After editing the sources, you need to update the xcframeworks to reflect the changes.

To update the xcframework, run the following commands:

```shell
swift package update-xcframeworks
```