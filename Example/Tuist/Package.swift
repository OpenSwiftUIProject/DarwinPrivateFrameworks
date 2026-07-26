// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "ExampleDependencies",
    dependencies: [
        .package(path: "../../"),
    ]
)
