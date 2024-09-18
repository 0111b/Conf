// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Conf",
    products: [
        .library(name: "Conf", targets: ["Conf"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Conf",
            dependencies: [
            ]),
        .testTarget(
            name: "ConfTests",
            dependencies: ["Conf"])
    ]
)
