// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RepeatingHls",
    platforms: [.macOS(.v13), .iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "RepeatingHls",
            targets: ["RepeatingHls"]),
    ],
    dependencies: [
        .package(url: "https://github.com/httpswift/swifter", .upToNextMajor(from: "1.5.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "RepeatingHls",
            dependencies: [.product(name: "Swifter", package: "swifter")],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "RepeatingHlsTests",
            dependencies: ["RepeatingHls"]),
    ]
)
