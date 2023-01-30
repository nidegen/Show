// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Show",
  
  platforms: [
    .iOS(.v15), .macOS(.v11)
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
