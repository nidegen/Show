import SwiftUI
import AVKit

public struct VideoView: View {
  var video: Video
  
  public init(_ video: Video){
    self.video = video
  }
  public var body: some View {
    VideoPlayer(player: AVPlayer(url:  video.localURL))
  }
}

struct VideoView_Previews: PreviewProvider {
  static var previews: some View {
    VideoView(.testVideo)
  }
}
