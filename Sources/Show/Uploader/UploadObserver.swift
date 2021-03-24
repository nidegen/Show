import Foundation

public class UploadObserver: ObservableObject {
  @Published var uploads: [Id: UploadState] = [:]
  
  var tasks: [UploadTask] = []
  
  func update(task: UploadTask, state: UploadState) {
    if state == .completed {
      uploads.removeValue(forKey: task.id)
    } else {
      uploads[task.id] = state
    }
  }
}
