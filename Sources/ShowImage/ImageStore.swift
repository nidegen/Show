//
//  ImageStore.swift
//  Echo
//
//  Created by Nicolas Degen on 18.09.20.
//  Copyright © 2020 Echo Labs AG. All rights reserved.
//

import Foundation
import UIKit

public final class ImageStore {
  var cache = ImageCache()
  public var server: ImageServer
  
  public init(server: ImageServer) {
    self.server = server
  }
  
  public static var shared = ImageStore(server: MockServer())
    
  public func image(forId id: Id, type: ImageSizeClass = .original, completion: @escaping (UIImage?)->()) {
    if let cachedImage = cache.getImage(forId: id) {
      completion(cachedImage)
      return
    }
    server.image(forId: id, type: type) { image in
      completion(image)
      image.map {
        self.cache.setImage($0, forId: id)
      }
    }
  }
  
  @discardableResult
  public func uploadNewImage(_ photo: UIImage, id: Id = UUID().uuidString,
                      maxResolution: CGFloat? = nil, compression: CGFloat = 0.5, completion: ((Id?)->())? = nil) -> Id {
    server.uploadNewImage(photo, id: id, maxResolution: maxResolution, compression: compression, completion: completion)
    self.cache.setImage(photo, forId: id)
    return id
  }
  
  
  @discardableResult
  public func uploadNewImage(fromURL photoURL: URL, id: Id = UUID().uuidString, completion: ((Id?)->())? = nil) -> Id {
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
