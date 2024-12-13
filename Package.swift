// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

func envEnable(_ key: String, default defaultValue: Bool = false) -> Bool {
    guard let value = Context.environment[key] else {
        return defaultValue
    }
    if value == "1" {
        return true
    } else if value == "0" {
        return false
    } else {
        return defaultValue
    }
}
let releaseVersion = Context.environment["DARWIN_PRIVATE_FRAMEWORKS_TARGET_RELEASE"].flatMap { Int($0) } ?? 2024
let platforms: [SupportedPlatform] = switch releaseVersion {
case 2024: // iOS 18.0
    [
        .iOS(.v18),
        .macOS(.v15),
        .macCatalyst(.v18),
        .tvOS(.v18),
        .watchOS(.v10),
        .visionOS(.v2),
    ]
case 2021: // iOS 15.5
    [
        .iOS(.v15),
        .macOS(.v12),
        .macCatalyst(.v15),
        .tvOS(.v15),
        .watchOS(.v7),
    ]
default: []
}

let package = Package(
    name: "PrivateFrameworks",
    platforms: platforms,
    products: [
        .library(name: "AttributeGraph", targets: ["AttributeGraph"]),
    ],
    targets: [
        .binaryTarget(name: "AttributeGraph", path: "AG/\(releaseVersion)/AttributeGraph.xcframework"),
    ],
    cxxLanguageStandard: .cxx17
)
