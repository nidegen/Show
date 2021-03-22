import Foundation

public protocol UploadObserver: class {
  var id: Id { get }
  var progress: Float { get }
  func pause()
  func resume()
  var completion: Completion? { get set }
}
