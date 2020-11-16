import Foundation

public class VideoLoader: ObservableObject {
  @Published var video: Video?
  var id: Id = ""
  
  public init(store: VideoStore) {
    store.video(forId: id) { video in
      self.video = video
    }
  }
  
  private init(video: Video) {
    self.video = video
    id = video.id
  }
  
  public static var tester: VideoLoader { VideoLoader(video: .testVideo) }
}
