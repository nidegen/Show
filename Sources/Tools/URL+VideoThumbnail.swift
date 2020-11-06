import UIKit
import AVKit

func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?) -> ())) {
  DispatchQueue.global().async {
    let asset = AVAsset(url: url)
    let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
    avAssetImageGenerator.appliesPreferredTrackTransform = true //4
    let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
    do {
      let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
      let thumbImage = UIImage(cgImage: cgThumbImage) //7
      DispatchQueue.main.async { //8
        completion(thumbImage) //9
      }
    } catch {
      print(error.localizedDescription) //10
      DispatchQueue.main.async {
        completion(nil) //11
      }
    }
  }
}
