import UIKit.UIImage
import Photos

public class Video {
  public let id: Id
  public let localURL: URL
  public var webURL: URL?
  public var thumbnail: UIImage?
  
  public init(id: Id, localURL: URL) {
    self.id = id
    self.localURL = localURL
  }
}

extension Video {
  func requestAuthorization(completion: @escaping ()->Void) {
    if PHPhotoLibrary.authorizationStatus() == .notDetermined {
      PHPhotoLibrary.requestAuthorization { (status) in
        DispatchQueue.main.async {
          completion()
        }
      }
    } else if PHPhotoLibrary.authorizationStatus() == .authorized{
      completion()
    }
  }
  
  func saveToAlbum(_ completion: ((Error?) -> Void)?) {
    requestAuthorization {
      PHPhotoLibrary.shared().performChanges({
        let request = PHAssetCreationRequest.forAsset()
        request.addResource(with: .video, fileURL: self.localURL, options: nil)
      }) { (result, error) in
        DispatchQueue.main.async {
          if let error = error {
            print(error.localizedDescription)
          } else {
            print("Saved successfully")
          }
          completion?(error)
        }
      }
    }
  }
}

public extension Video {
  static var testVideo: Video {
    return Video(id: "testVideo", localURL: URL(fileURLWithPath: "test"))
  }
}
