// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Either",
    platforms: [
        .macOS(.v10_10), .iOS(.v11), .tvOS(.v11), .watchOS(.v2)
    ],
    products: [
        .library(name: "Either", targets: ["Either"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Either", 
            dependencies: []
        ),
         .testTarget(
            name: "EitherTests",
            dependencies: ["Either"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)