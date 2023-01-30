import Foundation

public final class ImageStore {
  public var server: ImageServer
  public var cache: ImageCache
  
  public init(server: ImageServer, cache: ImageCache = ImageCache()) {
    self.server = server
    self.cache = cache
  }
  
  public static var mock = ImageStore(server: MockServer())
  
  public func image(forId id: Id, format: ImageFormat = .preview) async throws -> UIImage {
    if let cachedImage = cache.getImage(forId: id, format: format) {
      return cachedImage
    }
    
    if let image = try? await server.image(forId: id, format: format) {
      self.cache.setImage(image, forId: id, format: format)
      return image
    } else if format != .original {
      if let image = try? await self.server.image(forId: id, format: .original) {
        var resized: UIImage = image.resize(clampingMin: format.maxSmallerResolution) ?? image
        if format == .thumbnailSquared {
          resized = resized.squared() ?? resized
        }
        self.cache.setImage(resized, forId: id, format: format)
        return resized
      }
    }
    throw NSError()
  }

  public func getImages(ids: [Id], ofSize format: ImageFormat = .original) async throws -> [UIImage] {
    try await ids.asyncCompactMap { id in
      try await self.image(forId: id, format: format)
    }
  }
  
  @discardableResult
  public func uploadNewImage(_ photo: UIImage, id: Id = UUID().uuidString,
                             maxResolution: CGFloat? = nil, compression: CGFloat = 0.5, completion: Completion? = nil) -> Id {
    server.uploadNewImage(photo, id: id, maxResolution: maxResolution, compression: compression, completion: completion)
    self.cache.setImage(photo, forId: id)
    return id
  }

  public func deleteImage(withId id: Id) async throws {
    try await server.deleteImage(withId: id)
    cache.deleteImage(withId: id)
  }
  
  
  @discardableResult
  public func uploadNewImage(fromURL photoURL: URL, id: Id = UUID().uuidString, completion: Completion? = nil) -> Id {
    server.uploadNewImage(fromURL: photoURL, id: id, completion: completion)
    UIImage(contentsOfFile: photoURL.path).map {
      self.cache.setImage($0, forId: id)
    }
    return id
  }
}

extension Sequence {
  func asyncCompactMap<T>(
    _ transform: (Element) async throws -> T?
  ) async rethrows -> [T] {
    var values = [T]()

    for element in self {
      if let transformed = try await transform(element) {
        values.append(transformed)
      }
    }

    return values
  }
  
  func asyncMap<T>(
    _ transform: (Element) async throws -> T
  ) async rethrows -> [T] {
    var values = [T]()

    for element in self {
      try await values.append(transform(element))
    }

    return values
  }
}
