import Foundation

public enum UploadState: Equatable {
  case paused(Float), uploading(Float), completed, failed
}

public protocol UploadTask: AnyObject {
  var id: Id { get }
  var localImageURL: URL { get }
  
  var state: UploadState { get }
  
  func pause()
  func resume()
  
  var onStateChange: (UploadTask) -> () { get set }
}
