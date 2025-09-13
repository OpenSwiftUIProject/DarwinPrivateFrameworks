// swift-tools-version: 6.0

import PackageDescription

let releaseVersion = Context.environment["DARWIN_PRIVATE_FRAMEWORKS_TARGET_RELEASE"].flatMap { Int($0) } ?? 2024
let platforms: [SupportedPlatform] = switch releaseVersion {
    case 2024: [.iOS(.v18), .macOS(.v15), .macCatalyst(.v18), .tvOS(.v18), .watchOS(.v10), .visionOS(.v2)]
    case 2021: [.iOS(.v15), .macOS(.v12), .macCatalyst(.v15), .tvOS(.v15), .watchOS(.v7)]
    default: []
}

let package = Package(
    name: "DarwinPrivateFrameworks",
    platforms: platforms,
    products: [
        .library(name: "AttributeGraph", targets: ["AttributeGraph"]),
        .library(name: "RenderBox", targets: ["RenderBox"]),
        .library(name: "CoreUI", targets: ["CoreUI"]),
        .library(name: "BacklightServices", targets: ["BacklightServices"])
    ],
    targets: [
        .binaryTarget(name: "AttributeGraph", path: "AG/\(releaseVersion)/AttributeGraph.xcframework"),
        .binaryTarget(name: "RenderBox", path: "RB/2024/RenderBox.xcframework"),
        .binaryTarget(name: "CoreUI", path: "CoreUI/2024/CoreUI.xcframework"),
        .binaryTarget(name: "BacklightServices", path: "BLS/2024/BacklightServices.xcframework"),
        .plugin(
            name: "UpdateXCFrameworks",
            capability: .command(
                intent: .custom(verb: "update-xcframeworks", description: "Update xcframeworks"),
                permissions: [.writeToPackageDirectory(reason: "Update xcframeworks")]
            )
        ),
    ],
    cxxLanguageStandard: .cxx17
)
