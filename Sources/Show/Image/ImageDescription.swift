import Foundation

public protocol ImageDescription: Identifiable, Hashable {
  var imageId: String { get }
}

extension String: ImageDescription {
  public var id: String {
    self
  }

  public var imageId: String {
    self
  }
}

