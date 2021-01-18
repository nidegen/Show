import Foundation
import UIKit

public final class ImageStore {
  public var server: ImageServer
  public var cache: ImageCache
  
  public init(server: ImageServer, cache: ImageCache = ImageCache()) {
    self.server = server
    self.cache = cache
  }
  
  public static var mock = ImageStore(server: MockServer())
  
  public func image(forId id: Id, sizeClass: ImageSizeClass = .original, completion: @escaping (UIImage?)->()) {
    
    if let cachedImage = cache.getImage(forId: id, ofSize: sizeClass) {
      completion(cachedImage)
      return
    }
    DispatchQueue.main.async { [self] in
      if sizeClass != .original,
         let largerImage = cache.getImage(forId: id, largerThan: sizeClass.nextLarger),
         var resized = largerImage.resized(toMax: sizeClass.maxSize) {
          if sizeClass == .thumbnailSquared,
             let sq = resized.squared() {
            resized = sq
          }
          cache.setImage(resized, forId: id, size: sizeClass)
          completion(resized)
      } else {
        server.image(forId: id, withSize: sizeClass) { image in
          var img = image
          if sizeClass != .original {
            img = image?.resized(toMax: sizeClass.maxSize)
            if sizeClass == .thumbnailSquared,
              let sq = image?.squared() {
              img = sq
            }
          }
          img.map {
            cache.setImage($0, forId: id, size: sizeClass)
          }
          completion(img)
        }
      }
    }
  }
  
  public func getImages(ids: [Id], ofSize sizeClass: ImageSizeClass = .original, completion: (([UIImage]) -> ())? = nil) {
    let group = DispatchGroup()
    var images = [UIImage]()
    for id in ids {
        group.enter()
      self.image(forId: id, sizeClass: sizeClass) { image in
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
  
  public func saveToLibrary(id: Id) {
    image(forId: id) { optionalImage in
      guard let image = optionalImage else { return }
      UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
    }
  }
}
