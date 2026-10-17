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

let sharedResources: ResourceFileElements = [
    "Resources/Assets.xcassets",
]

// The 2024 release artifacts come from iOS 18.5, macOS 15.5, and visionOS 2.5.
let deploymentTargets2024 = DeploymentTargets.multiplatform(
    iOS: "18.5",
    macOS: "15.5",
    visionOS: "2.5"
)

// MARK: - Project

let project = Project(
    name: "Example",
    targets: [
        // MARK: AGExample
        .target(
            name: "AGExample",
            destinations: [.iPhone, .iPad, .mac, .appleVision],
            product: .app,
            bundleId: "\(bundleIdPrefix).AGExample",
            deploymentTargets: deploymentTargets2024,
            infoPlist: .extendingDefault(with: defaultInfoPlist),
            sources: ["AGExample/**"],
            resources: sharedResources,
            dependencies: [
                .external(name: "AttributeGraph"),
            ],
            settings: .settings(base: baseSettings.merging([
                "SWIFT_OBJC_BRIDGING_HEADER": "AGExample/AGExample-Bridging-Header.h",
            ]))
        ),
        // MARK: RBExample
        .target(
            name: "RBExample",
            destinations: [.iPhone, .iPad, .mac, .appleVision],
            product: .app,
            bundleId: "\(bundleIdPrefix).RBExample",
            deploymentTargets: deploymentTargets2024,
            infoPlist: .extendingDefault(with: defaultInfoPlist),
            sources: ["RBExample/**"],
            resources: sharedResources,
            dependencies: [
                .external(name: "RenderBox"),
            ],
            settings: .settings(base: baseSettings)
        ),
        // MARK: CoreUIExample
        .target(
            name: "CoreUIExample",
            destinations: [.iPhone, .iPad, .mac, .appleVision],
            product: .app,
            bundleId: "\(bundleIdPrefix).CoreUIExample",
            deploymentTargets: deploymentTargets2024,
            infoPlist: .extendingDefault(with: defaultInfoPlist),
            sources: ["CoreUIExample/**"],
            resources: sharedResources,
            dependencies: [
                .external(name: "CoreUI"),
            ],
            settings: .settings(base: baseSettings)
        ),
        // MARK: CoreSVGExample
        .target(
            name: "CoreSVGExample",
            destinations: [.iPhone, .iPad, .mac, .appleVision],
            product: .app,
            bundleId: "\(bundleIdPrefix).CoreSVGExample",
            deploymentTargets: deploymentTargets2024,
            infoPlist: .extendingDefault(with: defaultInfoPlist),
            sources: ["CoreSVGExample/**"],
            resources: sharedResources,
            dependencies: [
                .external(name: "CoreSVG"),
            ],
            settings: .settings(base: baseSettings)
        ),
        // MARK: BLSExample
        .target(
            name: "BLSExample",
            destinations: [.iPhone, .iPad, .appleVision],
            product: .app,
            bundleId: "\(bundleIdPrefix).BLSExample",
            deploymentTargets: .multiplatform(
                iOS: "18.5",
                visionOS: "2.5"
            ),
            infoPlist: .extendingDefault(with: defaultInfoPlist),
            sources: ["BLSExample/**"],
            resources: sharedResources,
            dependencies: [
                .external(name: "BacklightServices"),
            ],
            settings: .settings(base: baseSettings)
        ),
        // MARK: GFExample
        .target(
            name: "GFExample",
            destinations: [.iPhone, .iPad, .mac],
            product: .app,
            bundleId: "\(bundleIdPrefix).GFExample",
            deploymentTargets: .multiplatform(
                iOS: "26.2",
                macOS: "26.2"
            ),
            infoPlist: .extendingDefault(with: defaultInfoPlist),
            sources: ["GFExample/**"],
            resources: sharedResources,
            dependencies: [
                .external(name: "Gestures"),
            ],
            settings: .settings(base: baseSettings)
        ),
        // MARK: FeatureFlagsExample
        .target(
            name: "FeatureFlagsExample",
            destinations: [.iPhone, .iPad, .mac, .appleVision],
            product: .app,
            bundleId: "\(bundleIdPrefix).FeatureFlagsExample",
            deploymentTargets: deploymentTargets2024,
            infoPlist: .extendingDefault(with: defaultInfoPlist),
            sources: ["FeatureFlagsExample/**"],
            resources: sharedResources,
            dependencies: [
                .external(name: "FeatureFlags"),
            ],
            settings: .settings(base: baseSettings)
        ),
        // MARK: SFSymbolsExample
        .target(
            name: "SFSymbolsExample",
            destinations: [.iPhone, .iPad, .mac, .appleVision],
            product: .app,
            bundleId: "\(bundleIdPrefix).SFSymbolsExample",
            deploymentTargets: deploymentTargets2024,
            infoPlist: .extendingDefault(with: defaultInfoPlist),
            sources: ["SFSymbolsExample/**"],
            resources: sharedResources,
            dependencies: [
                .external(name: "SFSymbols"),
            ],
            settings: .settings(base: baseSettings)
        ),
    ]
)
