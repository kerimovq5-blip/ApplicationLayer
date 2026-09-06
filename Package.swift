// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ApplicationLayer",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "ApplicationLayer",
            targets: ["ApplicationLayer"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/kerimovq5-blip/SilentMoonData",
            branch: "main"
        ),
        .package(
            url: "https://github.com/kerimovq5-blip/SilentMoonDomain",
            branch: "main"
        ),
        .package(
            url: "https://github.com/kerimovq5-blip/SilentMoonNetwork",
            branch: "main" ),
        .package(
            url: "https://github.com/kerimovq5-blip/PresentationLayer",
            branch: "main")
    ],
    targets: [
        .target(
            name: "ApplicationLayer",
            dependencies: [
                .product(name: "PresentationLayer", package: "PresentationLayer"),
                .product(name: "SilentMoonDomain", package: "SilentMoonDomain"),
                .product(name: "SilentMoonData", package: "SilentMoonData"),
                .product(name: "SilentMoonNetwork", package: "SilentMoonNetwork")
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
