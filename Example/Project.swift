import ProjectDescription

// MARK: - Constants

let bundleIdPrefix = "org.OpenSwiftUIProject.DarwinPrivateFrameworks.Example"

let baseSettings: SettingsDictionary = [
    "CODE_SIGN_STYLE": "Automatic",
    "DEVELOPMENT_TEAM": "VB7MJ8R223",
]

let defaultInfoPlist: [String: Plist.Value] = [
    "UILaunchScreen": [:],
]

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
            infoPlist: .extendingDefault(with: defaultInfoPlist),
            sources: ["AGExample_2021/**"],
            resources: ["AGExample_2021/Assets.xcassets"],
            dependencies: [
                .external(name: "AttributeGraph"),
            ],
            settings: .settings(base: baseSettings)
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
            infoPlist: .extendingDefault(with: defaultInfoPlist),
            sources: ["AGExample_2024/**"],
            resources: ["AGExample_2024/Assets.xcassets"],
            dependencies: [
                .external(name: "AttributeGraph"),
            ],
            settings: .settings(base: baseSettings.merging([
                "SWIFT_OBJC_BRIDGING_HEADER": "AGExample_2024/AGExample_2024-Bridging-Header.h",
            ]))
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
            infoPlist: .extendingDefault(with: defaultInfoPlist),
            sources: ["RBExample_2024/**"],
            resources: ["RBExample_2024/Assets.xcassets"],
            dependencies: [
                .external(name: "RenderBox"),
            ],
            settings: .settings(base: baseSettings)
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
            infoPlist: .extendingDefault(with: defaultInfoPlist),
            sources: ["CoreUIExample_2024/**"],
            resources: ["CoreUIExample_2024/Assets.xcassets"],
            dependencies: [
                .external(name: "CoreUI"),
            ],
            settings: .settings(base: baseSettings)
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
            infoPlist: .extendingDefault(with: defaultInfoPlist),
            sources: ["BLSExample_2024/**"],
            resources: ["BLSExample_2024/Assets.xcassets"],
            dependencies: [
                .external(name: "BacklightServices"),
            ],
            settings: .settings(base: baseSettings)
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
            infoPlist: .extendingDefault(with: defaultInfoPlist),
            sources: ["SFSymbolsExample_2024/**"],
            resources: ["SFSymbolsExample_2024/Assets.xcassets"],
            dependencies: [
                .external(name: "SFSymbols"),
            ],
            settings: .settings(base: baseSettings)
        ),
    ]
)
