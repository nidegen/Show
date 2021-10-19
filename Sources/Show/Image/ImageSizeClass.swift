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
  case original, thumbnail, preview, large, thumbnailSquared
  
  public var maxSmallerResolution: CGFloat {
    switch self {
    case .thumbnailSquared:
      return 200;
    case .thumbnail:
      return 180
    case .preview:
      return 720
    case .large:
      return 2048
    case .original:
      return .infinity
    }
  }
  
  public var nextLarger: ImageSizeClass {
    switch self {
    case .thumbnailSquared:
      return .thumbnail
    case .thumbnail:
      return .preview
    case .preview:
      return .large
    case .large:
      return .original
    case .original:
      return .original
    }
  }
  
  public var nextSmaller: ImageSizeClass {
    switch self {
    case .thumbnailSquared:
      return .thumbnailSquared
    case .thumbnail:
      return .thumbnailSquared
    case .preview:
      return .thumbnail
    case .large:
      return .preview
    case .original:
      return .large
    }
  }
}
