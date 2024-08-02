// swift-tools-version:5.6
import PackageDescription

// Enable to use bundled Circular Pro fonts (for licensed usage)
let useBundledFonts = false

let package = Package(
    name: "Orbit",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "Orbit", targets: ["Orbit"]),
        .library(name: "OrbitIllustrations", targets: ["OrbitIllustrations"]),
        .library(name: "OrbitStorybook", targets: ["OrbitStorybook"]),
        .plugin(name: "CheckDocumentation", targets: ["CheckDocumentation"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
            from: "1.17.3"
        ),
    ],
    targets: [
        .target(
            name: "Orbit",
            resources:
                useBundledFonts
                    ? [
                        .copy("Foundation/Icons/Icons.ttf"),
                        .copy("Foundation/Typography/Circular20-Black.otf"),
                        .copy("Foundation/Typography/Circular20-Bold.otf"),
                        .copy("Foundation/Typography/Circular20-Book.otf"),
                        .copy("Foundation/Typography/Circular20-Medium.otf"),
                      ]
                    : [.copy("Foundation/Icons/Icons.ttf")]
        ),
        .target(
            name: "OrbitIllustrations",
            dependencies: ["Orbit"]
        ),
        .target(
            name: "OrbitStorybook",
            dependencies: ["Orbit", "OrbitIllustrations"]
        ),
        .testTarget(
            name: "SnapshotTests",
            dependencies: [
                "Orbit",
                "OrbitIllustrations",
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
