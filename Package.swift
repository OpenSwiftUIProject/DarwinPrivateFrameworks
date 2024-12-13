// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let releaseVersion = Context.environment["DARWIN_PRIVATE_FRAMEWORKS_TARGET_RELEASE"].flatMap { Int($0) } ?? 2024
let platforms: [SupportedPlatform] = switch releaseVersion {
    case 2024: [.iOS(.v18), .macOS(.v15), .macCatalyst(.v18), .tvOS(.v18), .watchOS(.v10), .visionOS(.v2)]
    case 2021: [.iOS(.v15), .macOS(.v12), .macCatalyst(.v15), .tvOS(.v15), .watchOS(.v7)]
    default: []
}

let package = Package(
    name: "PrivateFrameworks",
    platforms: platforms,
    products: [
        .library(name: "AttributeGraph", targets: ["AttributeGraph"]),
    ],
    targets: [
        .plugin(
            name: "UpdateModule",
            capability: .command(
                intent: .custom(verb: "update-module", description: "Update xcframework"),
                permissions: [.writeToPackageDirectory(reason: "Update xcframework")]
            )
        ),
    ],
    cxxLanguageStandard: .cxx17
)

if FileManager.default.fileExists(atPath: Context.packageDirectory.appending("AG/\(releaseVersion)/AttributeGraph.xcframework")) {
    package.targets.append(
        .binaryTarget(name: "AttributeGraph", path: "AG/\(releaseVersion)/AttributeGraph.xcframework")
    )
} else {
    package.targets.append(
        .target(name: "AttributeGraph")
    )
}
