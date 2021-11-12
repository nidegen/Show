#if canImport(AppKit)
import AppKit

extension NSImage {
  var isPortrait: Bool { size.height > size.width }
  var isLandscape: Bool { size.width > size.height }
  var breadth: CGFloat { min(size.width, size.height) }
  var breadthSize: CGSize { .init(width: breadth, height: breadth) }

  var newX: CGFloat { isLandscape ? ((size.width - size.height) / 2).rounded(.down) : 0 }
  var newY: CGFloat { isPortrait ? ((size.height - size.width) / 2).rounded(.down) : 0 }

  public func squared() -> NSImage? {
    let originalSize = self.size
    var sideSize : CGFloat = 0
    if(originalSize.width > originalSize.height) {
      sideSize = originalSize.height
    } else {
      sideSize = originalSize.width
    }
    
    var originalImageRect : CGRect = CGRect(x: 0, y: 0, width: originalSize.width, height: originalSize.height)
    guard let imageRef = self.cgImage(forProposedRect: &originalImageRect, context: nil, hints: nil) else { return nil }
    
    let thumbnailRect = CGRect(x: (originalSize.width / 2 - sideSize / 2), y: (originalSize.height / 2 - sideSize / 2), width: sideSize, height: sideSize)
    
    let drawImage = imageRef.cropping(to: thumbnailRect);
    
    return NSImage(cgImage: drawImage!, size: NSSize(width: sideSize, height: sideSize))
  }
}
#endif
