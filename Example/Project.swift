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
        // MARK: AGExample
        .target(
            name: "AGExample",
            destinations: [.iPhone, .iPad, .mac, .appleVision],
            product: .app,
            bundleId: "\(bundleIdPrefix).AGExample",
            deploymentTargets: .multiplatform(
                iOS: "18.0",
                macOS: "15.0",
                visionOS: "2.0"
            ),
            infoPlist: .extendingDefault(with: defaultInfoPlist),
            sources: ["AGExample/**"],
            resources: ["AGExample/Assets.xcassets"],
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
            deploymentTargets: .multiplatform(
                iOS: "18.0",
                macOS: "15.0",
                visionOS: "2.0"
            ),
            infoPlist: .extendingDefault(with: defaultInfoPlist),
            sources: ["RBExample/**"],
            resources: ["RBExample/Assets.xcassets"],
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
            deploymentTargets: .multiplatform(
                iOS: "18.0",
                macOS: "15.0",
                visionOS: "2.0"
            ),
            infoPlist: .extendingDefault(with: defaultInfoPlist),
            sources: ["CoreUIExample/**"],
            resources: ["CoreUIExample/Assets.xcassets"],
            dependencies: [
                .external(name: "CoreUI"),
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
            resources: ["BLSExample/Assets.xcassets"],
            dependencies: [
                .external(name: "BacklightServices"),
            ],
            settings: .settings(base: baseSettings)
        ),
        // MARK: SFSymbolsExample
        .target(
            name: "SFSymbolsExample",
            destinations: [.iPhone, .iPad, .mac],
            product: .app,
            bundleId: "\(bundleIdPrefix).SFSymbolsExample",
            deploymentTargets: .multiplatform(
                iOS: "18.5",
                macOS: "15.5"
            ),
            infoPlist: .extendingDefault(with: defaultInfoPlist),
            sources: ["SFSymbolsExample/**"],
            resources: ["SFSymbolsExample/Assets.xcassets"],
            dependencies: [
                .external(name: "SFSymbols"),
            ],
            settings: .settings(base: baseSettings)
        ),
    ]
)
