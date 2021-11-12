import SwiftUI
#if canImport(UIKit)
@_exported import UIKit.UIImage
#elseif canImport(AppKit)
import AppKit

public typealias UIImage = NSImage
public extension Image {
  init(uiImage: UIImage) {
    self.init(nsImage: uiImage)
  }
}
public extension NSImage {
  convenience init?(systemName: String) {
    self.init(systemSymbolName: systemName, accessibilityDescription: nil)
  }
}
#endif

