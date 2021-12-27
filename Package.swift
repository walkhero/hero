// swift-tools-version:5.5
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
        .package(name: "Archivable", url: "https://github.com/archivable/package.git", .branch("main"))
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
