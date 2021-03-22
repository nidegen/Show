import Foundation
import UIKit

class Uploader: ObservableObject {
  init(server: ImageServer, cache: ImageCache) {
    self.server = server
    self.cache = cache
  }
  
  @Published var isUploading = false
  @Published var totalProgress = 0.0
  
  @Published var uploads: [UploadObserver] = []
  
  var server: ImageServer
  var cache: ImageCache
  
  @discardableResult
  public func uploadNewImage(_ photo: UIImage, id: Id = UUID().uuidString,
                             maxResolution: CGFloat? = nil, compression: CGFloat = 0.5, completion: Completion? = nil) -> Id {
    let observer = server.uploadNewImage(photo, id: id, maxResolution: maxResolution, compression: compression, completion: completion)
    self.cache.setImage(photo, forId: id)
    return id
  }
  
  
  @discardableResult
  public func uploadNewImage(fromURL photoURL: URL, id: Id = UUID().uuidString, completion: Completion? = nil) -> Id {
    let observer = server.uploadNewImage(fromURL: photoURL, id: id, completion: completion)
    uploads.append(observer)
    UIImage(contentsOfFile: photoURL.path).map {
      self.cache.setImage($0, forId: id)
    }
    return id
  }
}
