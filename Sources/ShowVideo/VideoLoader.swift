import Foundation

class VideoLoader: ObservableObject {
  @Published var video: Video?
  var id: Id = ""
  
  init(videoServer: VideoStore) {
    videoServer.video(forId: id) { video in
      self.video = video
    }
  }
  
}
