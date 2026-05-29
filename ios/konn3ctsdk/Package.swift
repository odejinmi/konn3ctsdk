// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "konn3ctsdk",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "konn3ctsdk", targets: ["konn3ctsdk"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "konn3ctsdk",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
