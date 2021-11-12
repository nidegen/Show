#if canImport(AppKit)
import AppKit.NSImage

public extension NSImage {
  var maxSize: CGFloat {
    max(size.width, size.height)
  }

  var minSize: CGFloat {
    min(size.width, size.height)
  }


  func resized(toMax maxResolution: CGFloat) -> NSImage? {
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

  func resize(clampingMin maxResolution: CGFloat) -> NSImage? {
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

  func resized(clampingMax maxResolution: CGFloat) -> NSImage? {
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

  func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> NSImage? {
    self.resized(to: CGSize(width: width, height: CGFloat(ceil(width / size.width * size.height))))
  }
  
  func resized(toHeight height: CGFloat, isOpaque: Bool = true) -> NSImage? {
    self.resized(to: CGSize(width: CGFloat(ceil(size.width * height / size.height)), height: height))
  }
  
  func resized(to newSize: NSSize) -> NSImage? {
    if let bitmapRep = NSBitmapImageRep(
      bitmapDataPlanes: nil, pixelsWide: Int(newSize.width), pixelsHigh: Int(newSize.height),
      bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
      colorSpaceName: .calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0
    ) {
      bitmapRep.size = newSize
      NSGraphicsContext.saveGraphicsState()
      NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmapRep)
      draw(in: NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height), from: .zero, operation: .copy, fraction: 1.0)
      NSGraphicsContext.restoreGraphicsState()
      
      let resizedImage = NSImage(size: newSize)
      resizedImage.addRepresentation(bitmapRep)
      return resizedImage
    }
    
    return nil
  }
  
  func jpegData(compressionQuality: CGFloat) -> Data? {
    guard let rep = self.representations.first as? NSBitmapImageRep else { return nil }
    return rep.representation(using: .jpeg, properties: [NSBitmapImageRep.PropertyKey.compressionFactor : compressionQuality])
  }
}
#endif
