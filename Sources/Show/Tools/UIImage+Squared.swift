import UIKit

extension UIImage {
  var isPortrait:  Bool    { size.height > size.width }
  var isLandscape: Bool    { size.width > size.height }
  var breadth:     CGFloat { min(size.width, size.height) }
  var breadthSize: CGSize  { .init(width: breadth, height: breadth) }
  
  var newX: CGFloat { isLandscape ? ((size.width - size.height)/2).rounded(.down) : 0 }
  var newY: CGFloat { isPortrait  ? ((size.height - size.width)/2).rounded(.down) : 0 }
  
  public func squared(size: CGFloat? = nil, isOpaque: Bool = false) -> UIImage? {
    guard let cgImage = cgImage?
            .cropping(to: .init(origin: .init(x: newX, y: newY),
                                size: breadthSize)) else { return nil }
    let format = imageRendererFormat
    format.opaque = isOpaque
    let squared = UIGraphicsImageRenderer(size: breadthSize, format: format).image { _ in
      UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation)
        .draw(in: .init(origin: .zero, size: breadthSize))
    }
    
    if let size = size, let resized = squared.resize(clampingMin: size) {
      return resized
    } else {
      return squared
    }
  }
}
