import SwiftUI
import AVKit

public struct VideoView: View {
  var loader: VideoLoader
  
  public init(loader: VideoLoader) {
    self.loader = loader
  }
  
  public var body: some View {
    if let video = self.loader.video {
      VideoPlayer(player: AVPlayer(url:  video.localURL))
    } else {
      ZStack {
        Color.black
        Text("Loading video...")
      }
    }
  }
}

struct VideoView_Previews: PreviewProvider {
  static var previews: some View {
    VideoView(loader: .tester)
  }
}
