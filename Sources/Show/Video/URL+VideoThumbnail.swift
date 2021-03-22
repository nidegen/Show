import UIKit
import AVKit

extension URL {
  func getVideoThumbnail(completion: @escaping ((_ image: UIImage?) -> ())) {
    if !self.isFileURL {
      print("Error: Only support file urls")
      completion(nil)
    }
    DispatchQueue.global().async {
      let asset = AVAsset(url: self)
      let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
      avAssetImageGenerator.appliesPreferredTrackTransform = true
      let thumnailTime = CMTimeMake(value: 2, timescale: 1)
      do {
        let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
        let thumbImage = UIImage(cgImage: cgThumbImage)
        DispatchQueue.main.async {
          completion(thumbImage)
        }
      } catch {
        print(error.localizedDescription)
        DispatchQueue.main.async {
          completion(nil)
        }
      }
    }
  }
}
