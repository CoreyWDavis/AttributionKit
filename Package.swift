// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "AttributionKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "AttributionKit",
            targets: ["AttributionKit"]),
    ],
    targets: [
        .executableTarget(
            name: "AttributionCLI",
            dependencies: ["AttributionKit"],
            path: "AttributionCLI"),
        .target(
            name: "AttributionKit",
            path: "AttributionKit")
    ]
)
