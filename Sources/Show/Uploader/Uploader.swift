import Foundation
import UIKit

class Uploader: ObservableObject {
  init(server: ImageServer, cache: ImageCache) {
    self.server = server
    self.cache = cache
  }
  
  @Published var isUploading = false
  @Published var totalProgress = 0.0
  
  @Published var uploads: [Id: UploadState] = [:]
  
  private(set) var tasks: [UploadTask] = []
  
  var server: ImageServer
  var cache: ImageCache
  
  fileprivate func update(task: UploadTask, state: UploadState) {
    if state == .completed {
      uploads.removeValue(forKey: task.id)
    } else {
      uploads[task.id] = state
    }
  }
  
  func add(task: UploadTask) {
    task.onStateChange = { task in
      self.update(task: task, state: task.state)
      if task.state == .completed {
        self.uploads.removeValue(forKey: task.id)
      }
      if task.state == .failed {
        self.uploads.removeValue(forKey: task.id)
      }
    }
  }
  
  @discardableResult
  public func uploadNewImage(_ photo: UIImage, id: Id = UUID().uuidString,
                             maxResolution: CGFloat? = nil, compression: CGFloat = 0.5, completion: Completion? = nil) -> UploadTask {
    let task = server.uploadNewImage(photo, id: id, maxResolution: maxResolution, compression: compression, completion: completion)
    add(task: task)
    self.cache.setImage(photo, forId: id)
    return task
  }
  
  
  @discardableResult
  public func uploadNewImage(fromURL photoURL: URL, id: Id = UUID().uuidString, completion: Completion? = nil) -> UploadTask {
    let task = server.uploadNewImage(fromURL: photoURL, id: id, completion: completion)
    add(task: task)
    UIImage(contentsOfFile: photoURL.path).map {
      self.cache.setImage($0, forId: id)
    }
    return task
  }
}
