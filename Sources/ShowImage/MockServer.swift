import Foundation
import UIKit


class MockServer: ImageServer {
  var store: [Id: UIImage] = [:]
  func uploadNewImage(fromURL photoURL: URL, id: Id, completion: ((Id?) -> ())?) -> Id {
    if let image = try? UIImage(data: Data(contentsOf: photoURL)) {
      return uploadNewImage(image, id: id, maxResolution: nil, compression: 0.6 , completion: completion)
    } else {
      completion?(nil)
      return id
    }
  }
  func uploadNewImage(_ photo: UIImage, id: Id, maxResolution: CGFloat?, compression: CGFloat, completion: ((Id?) -> ())?) -> Id {
    store[id] = photo
    completion?(id)
    return id
  }
  
  func image(forId id: Id, withSize size: ImageSizeClass, completion: @escaping (UIImage?) -> ()) {
    let image = store[id]
    completion(image)
  }
  
  func deleteImage(withId id: Id) {
    store[id] = nil
  }
  
  func getNewImage(id: Id) -> UIImage? {
    try? UIImage(data: Data(contentsOf: URL(string: "https://source.unsplash.com/random/\(id)")!))

  }
}
