import Foundation

class ImageLoader: ObservableObject {
  @Published var downloadedImage: UIImage?
  
  var id: Id?
  var format: ImageFormat?
  
  func load(id: Id, store: ImageStore, format: ImageFormat = .preview) {
    if (self.id == id && self.format == format) {
      return
    }
    self.id = id
    self.format = format
    store.image(forId: id, format: format) { image in
      self.downloadedImage = image
    }
  }
}
