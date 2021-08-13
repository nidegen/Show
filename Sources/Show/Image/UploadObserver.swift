import Foundation
import UIKit

public class UploadObserver: ObservableObject {
  
  @Published public var shouldDisplay = false
  @Published public var totalProgress: Float = 0.0
  
  @Published public var uploads: [Id: UploadState] = [:]
  
  private(set) var tasks: [UploadTask] = []
  
  var onUploadStart: (() -> ())?
  
  public init() {}
  
  fileprivate func update(task: UploadTask) {
    uploads[task.id] = task.state
    if task.state == .completed || task.state == .failed {
      uploads.removeValue(forKey: task.id)
    } else {
      uploads[task.id] = task.state
    }
    var total: Float = 0.0
    for task in tasks {
      switch task.state {
      case .completed:
        total += 1.0
      case .paused(let progress):
        total += progress
      case .uploading(let progress):
        total += progress
      case .failed:
        break
      }
    }
    totalProgress = total / Float(tasks.count)
  }
  
  func add(task: UploadTask) {
    if tasks.isEmpty {
      onUploadStart?()
      shouldDisplay = true
    }
    task.onStateChange = self.update
    uploads[task.id] = task.state
    tasks.append(contentsOf: tasks)
  }
}
