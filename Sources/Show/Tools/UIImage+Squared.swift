#if canImport(UIKit)
extension UIImage.Orientation {
  var changingspectRatio: Bool {
    self == .left || self == .leftMirrored || self == .right || self == .rightMirrored
  }
}

extension UIImage {
  var isPortrait: Bool { size.height > size.width && !imageOrientation.changingspectRatio }
  var isLandscape: Bool { size.width > size.height && !imageOrientation.changingspectRatio }
  var breadth: CGFloat { min(size.width, size.height) }
  var breadthSize: CGSize { .init(width: breadth, height: breadth) }

  var newX: CGFloat { isLandscape ? ((size.width - size.height) / 2).rounded(.down) : 0 }
  var newY: CGFloat { isPortrait ? ((size.height - size.width) / 2).rounded(.down) : 0 }

  public func squared(size: CGFloat? = nil) -> UIImage? {
    if let size = size {
      return resize(clampingMin: size)?.cropToSquare()
    } else {
      return cropToSquare()
    }
  }
  
  func cropToSquare() -> UIImage? {
    var imageHeight = size.height
    var imageWidth = size.width
    
    if imageHeight > imageWidth {
      imageHeight = imageWidth
    } else {
      imageWidth = imageHeight
    }
    
    let size = CGSize(width: imageWidth, height: imageHeight)
    
    let refWidth : CGFloat = CGFloat(cgImage!.width)
    let refHeight : CGFloat = CGFloat(cgImage!.height)
    
    let x = (refWidth - size.width) / 2
    let y = (refHeight - size.height) / 2
    
    let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
    if let imageRef = cgImage?.cropping(to: cropRect) {
      return UIImage(cgImage: imageRef, scale: 0, orientation: imageOrientation)
    }
    
    return nil
  }
}
#endif
