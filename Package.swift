// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Show",
  
  platforms: [
    .iOS(.v13),
  ],
  
  products: [
    .library(
      name: "Show",
      targets: ["Show"]),
  ],
  dependencies: [
    // .package(url: /* package url */, from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "Show",
      dependencies: ["ImageStore", "VideoStore", "Tools"]),
    .target(
      name: "ImageStore",
      dependencies: []),
    .target(
      name: "VideoStore",
      dependencies: []),
    .target(
      name: "Tools",
      dependencies: []),
    .testTarget(
      name: "ShowTests",
      dependencies: ["Show"]),
    .testTarget(
      name: "ToolsTests",
      dependencies: ["Tools"]),
  ]
)
