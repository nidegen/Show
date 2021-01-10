// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Show",
  
  platforms: [
    .iOS(.v14),
  ],
  
  products: [
    .library(
      name: "Show",
      targets: ["Show", "ShowImage", "ShowVideo", "Tools"]),
  ],
  dependencies: [
    // .package(url: /* package url */, from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "Show",
      dependencies: ["ShowImage", "ShowVideo", "Tools"]),
    .target(
      name: "ShowImage",
      dependencies: ["Tools"]),
    .target(
      name: "ShowVideo",
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
