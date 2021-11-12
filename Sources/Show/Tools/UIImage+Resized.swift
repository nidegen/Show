#if canImport(UIKit)
import UIKit

public extension UIImage {
  var maxSize: CGFloat {
    max(size.width, size.height)
  }

  var minSize: CGFloat {
    min(size.width, size.height)
  }
  
  func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
    let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
    let format = imageRendererFormat
    format.opaque = isOpaque
    return UIGraphicsImageRenderer(size: canvas, format: format).image {
      _ in draw(in: CGRect(origin: .zero, size: canvas))
    }
  }

  func resized(toMax maxResolution: CGFloat) -> UIImage? {
    if self.size.width > self.size.height {
      if self.size.width > maxResolution {
        return self.resized(toWidth: maxResolution)
      }
    } else {
      if self.size.height > maxResolution {
        return self.resized(toHeight: maxResolution)
      }
    }
    return nil
  }

  func resize(clampingMin maxResolution: CGFloat) -> UIImage? {
    if self.size.height > self.size.width {
      if self.size.width > maxResolution {
        return self.resized(toWidth: maxResolution)
      }
    } else {
      if self.size.height > maxResolution {
        return self.resized(toHeight: maxResolution)
      }
    }
    return nil
  }

  func resized(clampingMax maxResolution: CGFloat) -> UIImage? {
    if self.size.width > self.size.height {
      if self.size.width > maxResolution {
        return self.resized(toWidth: maxResolution)
      }
    } else {
      if self.size.height > maxResolution {
        return self.resized(toHeight: maxResolution)
      }
    }
    return nil
  }

  func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
    let canvas = CGSize(width: width, height: CGFloat(ceil(width / size.width * size.height)))
    let format = imageRendererFormat
    format.opaque = isOpaque
    return UIGraphicsImageRenderer(size: canvas, format: format).image {
      _ in draw(in: CGRect(origin: .zero, size: canvas))
    }
  }

  func resized(toHeight height: CGFloat, isOpaque: Bool = true) -> UIImage? {
    let canvas = CGSize(width: CGFloat(ceil(size.width * height / size.height)), height: height)
    let format = imageRendererFormat
    format.opaque = isOpaque
    return UIGraphicsImageRenderer(size: canvas, format: format).image {
      _ in draw(in: CGRect(origin: .zero, size: canvas))
    }
  }
}

#endif
