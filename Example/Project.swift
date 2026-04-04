import ProjectDescription

// MARK: - Constants

let bundleIdPrefix = "org.OpenSwiftUIProject.DarwinPrivateFrameworks.Example"

// MARK: - Project

let project = Project(
    name: "Example",
    targets: [
        // MARK: AGExample_2021
        .target(
            name: "AGExample_2021",
            destinations: [.iPhone, .iPad, .mac],
            product: .app,
            bundleId: "\(bundleIdPrefix).AGExample-2021",
            deploymentTargets: .multiplatform(
                iOS: "15.0",
                macOS: "12.0"
            ),
            sources: ["AGExample_2021/**"],
            resources: ["AGExample_2021/Assets.xcassets"],
            dependencies: [
                .xcframework(path: "../AG/2021/AttributeGraph.xcframework"),
            ]
        ),
        // MARK: AGExample_2024
        .target(
            name: "AGExample_2024",
            destinations: [.iPhone, .iPad, .mac, .appleVision],
            product: .app,
            bundleId: "\(bundleIdPrefix).AGExample-2024",
            deploymentTargets: .multiplatform(
                iOS: "18.0",
                macOS: "15.0",
                visionOS: "2.0"
            ),
            sources: ["AGExample_2024/**"],
            resources: ["AGExample_2024/Assets.xcassets"],
            dependencies: [
                .external(name: "AttributeGraph"),
            ]
        ),
        // MARK: RBExample_2024
        .target(
            name: "RBExample_2024",
            destinations: [.iPhone, .iPad, .mac, .appleVision],
            product: .app,
            bundleId: "\(bundleIdPrefix).RBExample-2024",
            deploymentTargets: .multiplatform(
                iOS: "18.0",
                macOS: "15.0",
                visionOS: "2.0"
            ),
            sources: ["RBExample_2024/**"],
            resources: ["RBExample_2024/Assets.xcassets"],
            dependencies: [
                .external(name: "RenderBox"),
            ]
        ),
        // MARK: CoreUIExample_2024
        .target(
            name: "CoreUIExample_2024",
            destinations: [.iPhone, .iPad, .mac, .appleVision],
            product: .app,
            bundleId: "\(bundleIdPrefix).CoreUIExample-2024",
            deploymentTargets: .multiplatform(
                iOS: "18.0",
                macOS: "15.0",
                visionOS: "2.0"
            ),
            sources: ["CoreUIExample_2024/**"],
            resources: ["CoreUIExample_2024/Assets.xcassets"],
            dependencies: [
                .external(name: "CoreUI"),
            ]
        ),
        // MARK: BLSExample_2024
        .target(
            name: "BLSExample_2024",
            destinations: [.iPhone, .iPad, .appleVision],
            product: .app,
            bundleId: "\(bundleIdPrefix).BLSExample-2024",
            deploymentTargets: .multiplatform(
                iOS: "18.5",
                visionOS: "2.5"
            ),
            sources: ["BLSExample_2024/**"],
            resources: ["BLSExample_2024/Assets.xcassets"],
            dependencies: [
                .external(name: "BacklightServices"),
            ]
        ),
        // MARK: SFSymbolsExample_2024
        .target(
            name: "SFSymbolsExample_2024",
            destinations: [.iPhone, .iPad, .mac],
            product: .app,
            bundleId: "\(bundleIdPrefix).SFSymbolsExample-2024",
            deploymentTargets: .multiplatform(
                iOS: "18.5",
                macOS: "15.5"
            ),
            sources: ["SFSymbolsExample_2024/**"],
            resources: ["SFSymbolsExample_2024/Assets.xcassets"],
            dependencies: [
                .external(name: "SFSymbols"),
            ]
        ),
    ]
)
