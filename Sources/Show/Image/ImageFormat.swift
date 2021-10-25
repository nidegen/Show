import Foundation
import CoreGraphics

public typealias Id = String
public typealias ImageSizeClass = ImageFormat

public enum ImageFormat: String, CaseIterable {
  case original, thumbnail, preview, large, thumbnailSquared
  
  public var name: String {
      switch self {
      case .thumbnailSquared:
        return "thumbnail_squared"
      case .thumbnail:
        return "thumbnail"
      case .preview:
        return "preview"
      case .large:
        return "large"
      case .original:
        return "original"
      }
  }
  
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
