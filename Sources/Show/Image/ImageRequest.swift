import Foundation

public struct ImageRequest {
  public var imageId: Id
  public var formats: [ImageSizeClass]
  
  init(imageId: Id, format: ImageFormat, alternativeFormats: [ImageFormat] = []) {
    self.imageId = imageId
    self.formats = [format] + alternativeFormats
  }
}
