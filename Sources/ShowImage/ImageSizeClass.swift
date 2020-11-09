//
//  ImageSizeClass.swift
//  Echo
//
//  Created by Nicolas Degen on 19.09.20.
//  Copyright © 2020 Echo Labs AG. All rights reserved.
//

import Foundation

public typealias Id = String

public enum ImageSizeClass: String {
  case original, thumbnail, large
  
  public var nextLarger: ImageSizeClass {
    switch self {
    case .thumbnail:
      return .large
    case .large:
      return .original
    case .original:
      return .original
    }
  }
}
