import SwiftUI
import AVKit
import AVFoundation

struct VideoView: UIViewControllerRepresentable {
  var url: URL

  func makeUIViewController(context: UIViewControllerRepresentableContext<VideoView>) -> AVPlayerViewController {
    let player = AVPlayer(url: url)
    let playerViewController = AVPlayerViewController()
    player.preventsDisplaySleepDuringVideoPlayback = true
    player.playImmediately(atRate: 1)
    playerViewController.videoGravity = .resizeAspectFill
    playerViewController.player = player
    return playerViewController
  }

  func updateUIViewController(
    _ uiViewController: AVPlayerViewController,
    context: UIViewControllerRepresentableContext<VideoView>
  ) {}

  func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }

  class Coordinator: NSObject {
    var parent: VideoView

    init(_ parent: VideoView) {
      self.parent = parent
    }
  }
}

@available(iOS 16.0, *)
struct VideoView_Previews: PreviewProvider {
  static var player: AVPlayer {
    let player = AVPlayer(
      url: URL(
        filePath: "/Users/nicolas/Desktop/video.mp4"
      )
    )
    player.preventsDisplaySleepDuringVideoPlayback = true
    player.playImmediately(atRate: 1)
    return player
  }

  static var previews: some View {
    TabView {
      Color.red
        .ignoresSafeArea()
        .tag(0)

      VideoPlayer(
        player: player
      )
      .ignoresSafeArea()

      VideoView(
        url: URL(
          filePath: "/Users/nicolas/Desktop/video.mp4"
        )
      )
        .allowsHitTesting(false)
        .ignoresSafeArea()
        .tag(1)

      Color.blue
        .ignoresSafeArea()
        .tag(2)
    }
    .tabViewStyle(.page)
    .ignoresSafeArea()
  }
}
