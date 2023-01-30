import Foundation

class ImageLoader: ObservableObject {
  @Published var downloadedImage: UIImage?
  
  var id: Id?
  var format: ImageFormat?
  
  func load(id: Id, store: ImageStore, format: ImageFormat = .preview) async {
    if (self.id == id && self.format == format) {
      return
    }
    self.id = id
    self.format = format
    self.downloadedImage = try? await store.image(forId: id, format: format)
  }
}
