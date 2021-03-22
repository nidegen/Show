import Foundation

class ImageUploader {
  public var uploads: [UploadObserver] = []
  public var server: ImageServer
  
  init(server: ImageServer) {
    self.server = server
  }
}
