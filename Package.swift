// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Orbit",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "Orbit", targets: ["Orbit"]),
        .library(name: "OrbitDynamic", type: .dynamic, targets: ["Orbit"]),
        .library(name: "OrbitStatic", type: .static, targets: ["Orbit"]),
    ],
    dependencies: [
        .package(name: "Lottie", url: "https://github.com/airbnb/lottie-ios.git", from: "3.2.3"),
    ],
    targets: [
        .target(
            name: "Orbit",
            dependencies: ["Lottie"],
            resources: [
                .copy("Foundation/Typography/CircularPro-Bold.otf"),
                .copy("Foundation/Typography/CircularPro-Medium.otf"),
                .copy("Foundation/Typography/CircularPro-Book.otf"),
                .copy("Foundation/Icons/Icons.ttf"),
                .copy("Support/Animations/Airport.json"),
            ]
        ),
    ]
)
