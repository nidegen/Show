import Foundation

public enum UploadState {
  case paused, uploading, finished, failed
}

public protocol UploadObserver: class {
  var id: Id { get }
  var progress: Float { get }
  func pause()
  func resume()
  var completion: Completion? { get set }
  var state: UploadState { get }
}
