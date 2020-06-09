// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Conf",
    products: [
        .library(name: "Conf", targets: ["Conf"]),
//        .executable(name: "Demo", targets: ["DemoApp"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "DemoApp",
            dependencies: [
                "Conf",
            ]),
        .testTarget(
            name: "DemoAppTests",
            dependencies: ["DemoApp"]),
        .target(
            name: "Conf",
            dependencies: [
            ]),
        .testTarget(
            name: "ConfTests",
            dependencies: ["Conf"]),
    ]
)
