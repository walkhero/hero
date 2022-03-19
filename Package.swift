// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "Hero",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "Hero",
            targets: ["Hero"]),
    ],
    dependencies: [
        .package(url: "https://github.com/archivable/package.git", branch: "main"),
        .package(url: "https://github.com/archivable/dater.git", branch: "main")
    ],
    targets: [
        .target(
            name: "Hero",
            dependencies: [
                .product(name: "Archivable", package: "package"),
                .product(name: "Dater", package: "dater")],
            path: "Sources"),
        .testTarget(
            name: "Tests",
            dependencies: ["Hero"],
            path: "Tests"),
    ]
)
