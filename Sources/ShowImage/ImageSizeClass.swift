//
//  ImageSizeClass.swift
//  Echo
//
//  Created by Nicolas Degen on 19.09.20.
//  Copyright © 2020 Echo Labs AG. All rights reserved.
//

import Foundation
import CoreGraphics

public typealias Id = String

public enum ImageSizeClass: String, CaseIterable {
  case original, thumbnail, large, thumbnailSquared
  
  public var maxSize: CGFloat {
    switch self {
    case .thumbnailSquared:
      return ImageSizeClass.thumbnail.maxSize;
    case .thumbnail:
      return 200
    case .large:
      return 1024
    case .original:
      return 8192
    }
  }
  
  public var nextLarger: ImageSizeClass {
    switch self {
    case .thumbnailSquared:
      return .thumbnail
    case .thumbnail:
      return .large
    case .large:
      return .original
    case .original:
      return .original
    }
  }
  
  public static func sizeClass(for imageSize: CGFloat) -> Self {
    var sizeClass = Self.original
    for tmp in ImageSizeClass.allCases {
      if tmp.maxSize > imageSize, tmp.maxSize < sizeClass.maxSize {
        sizeClass = tmp
      }
    }
    return sizeClass
  }
}
