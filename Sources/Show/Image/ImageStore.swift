import Foundation

public final class ImageStore {
  public var server: ImageServer
  public var cache: ImageCache
  
  public init(server: ImageServer, cache: ImageCache = ImageCache()) {
    self.server = server
    self.cache = cache
  }
  
  public static var mock = ImageStore(server: MockServer())
  
  public func image(forId id: Id, format: ImageFormat = .preview, completion: @escaping (UIImage?)->()) {
    
    if let cachedImage = cache.getImage(forId: id, format: format) {
      completion(cachedImage)
      return
    }
    
    server.image(forId: id, format: format) { image in
      if image == nil && format != .original {
        self.server.image(forId: id, format: .original) { image in
          if let image = image {
            var resized: UIImage = image.resize(clampingMin: format.maxSmallerResolution) ?? image
            if format == .thumbnailSquared {
              resized = resized.squared() ?? resized
            }
            self.cache.setImage(resized, forId: id, format: format)
            completion(resized)
          }
        }
      } else {
        image.map {
          self.cache.setImage($0, forId: id, format: format)
        }
        completion(image)
      }
    }
  }
  
  public func getImages(ids: [Id], ofSize format: ImageFormat = .original, completion: (([UIImage]) -> ())? = nil) {
    let group = DispatchGroup()
    var images = [UIImage]()
    for id in ids {
      group.enter()
      self.image(forId: id, format: format) { image in
        image.map { images.append($0) }
        group.leave()
      }
    }
    completion?(images)
  }
  
  @discardableResult
  public func uploadNewImage(_ photo: UIImage, id: Id = UUID().uuidString,
                             maxResolution: CGFloat? = nil, compression: CGFloat = 0.5, completion: Completion? = nil) -> Id {
    server.uploadNewImage(photo, id: id, maxResolution: maxResolution, compression: compression, completion: completion)
    self.cache.setImage(photo, forId: id)
    return id
  }
  
  
  @discardableResult
  public func uploadNewImage(fromURL photoURL: URL, id: Id = UUID().uuidString, completion: Completion? = nil) -> Id {
    server.uploadNewImage(fromURL: photoURL, id: id, completion: completion)
    UIImage(contentsOfFile: photoURL.path).map {
      self.cache.setImage($0, forId: id)
    }
    return id
  }
  
  public func deleteImage(withId id: Id) {
    server.deleteImage(withId: id)
    cache.deleteImage(withId: id)
  }
}
