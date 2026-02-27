// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "SwiftDate",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "SwiftDate", targets: ["SwiftDate"])
    ],
    targets: [
        .target(
            name: "SwiftDate",
            path: "Sources/SwiftDate",
            resources: [.copy("SwiftDate.bundle")]
        )
    ]
)
