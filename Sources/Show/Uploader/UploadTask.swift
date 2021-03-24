import Foundation

public enum UploadState: Equatable {
  case paused(Float), uploading(Float), completed, failed
}

public protocol UploadTask {
  var id: Id { get }
  var image: URL { get }
  
  var state: UploadState { get }
  
  func pause()
  func resume()
  
  var onStateChange: (UploadState) -> () { get set }
}
