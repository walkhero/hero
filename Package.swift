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
        .package(name: "Archivable", url: "https://github.com/archivable/package.git", .branch("main")),
        .package(name: "Dater", url: "https://github.com/archivable/dater.git", .branch("main"))
    ],
    targets: [
        .target(
            name: "Hero",
            dependencies: ["Archivable", "Dater"],
            path: "Sources"),
        .testTarget(
            name: "Tests",
            dependencies: ["Hero"],
            path: "Tests"),
    ]
)
