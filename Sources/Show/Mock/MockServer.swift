import Foundation
import UIKit


class MockServer: ImageServer {
  enum ServerError : Error {
    case couldNotLoadImage
  }
  
  var store: [Id: UIImage] = [:]
  func uploadNewImage(fromURL photoURL: URL, id: Id, completion: Completion? = nil) -> Id {
    if let image = try? UIImage(data: Data(contentsOf: photoURL)) {
      return uploadNewImage(image, id: id, maxResolution: nil, compression: 0.6 , completion: completion)
    } else {
      completion?(.failure(ServerError.couldNotLoadImage))
      return id
    }
  }
  
  func uploadNewImage(_ photo: UIImage, id: Id, maxResolution: CGFloat?, compression: CGFloat, completion: Completion? = nil) -> Id {
    store[id] = photo
    completion?(.success(id))
    return id
  }
  
  func image(forId id: Id, withSize size: ImageSizeClass, completion: @escaping (UIImage?) -> ()) {
    if let image = store[id] {
      completion(image)
    } else {
//      let new = try? UIImage(data: Data(contentsOf: URL(string: "https://source.unsplash.com/random/\(id)")!))
//      let new = UIImage(contentsOfFile: Bundle.main.url(forResource: "ErhKqMSXMAEIv1t", withExtension: "jpeg")!.path)
      let new = UIImage(systemName: id)
      if let image = new {
        store[id] = image
        completion(image)
      } else {
        completion(nil)
      }
    }
  }
  
  func deleteImage(withId id: Id) {
    store[id] = nil
  }
}
