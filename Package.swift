// swift-tools-version:5.6
import PackageDescription

// Enable to use bundled Circular Pro fonts (for licensed usage)
let useBundledFonts = false

let package = Package(
    name: "Orbit",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "Orbit", targets: ["Orbit"]),
        .library(name: "OrbitStorybook", targets: ["OrbitStorybook"]),
        .plugin(name: "CheckDocumentation", targets: ["CheckDocumentation"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
            from: "1.10.0"
        ),
    ],
    targets: [
        .target(
            name: "Orbit",
            resources:
                useBundledFonts
                    ? [
                        .copy("Foundation/Icons/Icons.ttf"),
                        .copy("Foundation/Typography/CircularPro-Bold.otf"),
                        .copy("Foundation/Typography/CircularPro-Medium.otf"),
                        .copy("Foundation/Typography/CircularPro-Book.otf"),
                      ]
                    : [.copy("Foundation/Icons/Icons.ttf")]
        ),
        .target(
            name: "OrbitStorybook",
            dependencies: ["Orbit"]
        ),
        .testTarget(
            name: "SnapshotTests",
            dependencies: [
                "Orbit",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        ),
        .plugin(
            name: "CheckDocumentation",
            capability: .command(
                intent: .custom(
                    verb: "check-documentation",
                    description: "Check if all public types are mentioned in the DocC archive."
                )
            )
        )
    ]
)
