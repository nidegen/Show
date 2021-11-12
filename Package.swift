// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Show",
  
  platforms: [
    .iOS(.v14), .macOS(.v11)
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
      name: "Show"),
    .testTarget(
      name: "ShowTests",
      dependencies: ["Show"]),
  ]
)
