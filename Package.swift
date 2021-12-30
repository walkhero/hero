// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "Hero",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .watchOS(.v7)
    ],
    products: [
        .library(
            name: "Hero",
            targets: ["Hero"]),
    ],
    dependencies: [
        .package(name: "Archivable", url: "https://github.com/archivable/package.git", .revision("02b6c26d3353ff5bfc92f26320f59d7aa94cd65d"))
    ],
    targets: [
        .target(
            name: "Hero",
            dependencies: ["Archivable"],
            path: "Sources"),
        .testTarget(
            name: "Tests",
            dependencies: ["Hero"],
            path: "Tests"),
    ]
)
