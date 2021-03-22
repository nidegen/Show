import AVKit

class VideoCompression {
  
  func fileOutput(_ output: AVCaptureFileOutput,
                  didFinishRecordingTo outputFileURL: URL,
                  from connections: [AVCaptureConnection],
                  error: Error?) {
    guard let data = try? Data(contentsOf: outputFileURL) else {
      return
    }
    
    print("File size before compression: \(Double(data.count / 1048576)) mb")
    
    let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + UUID().uuidString + ".mp4")
    compressVideo(inputURL: outputFileURL as URL,
                  outputURL: compressedURL, preset: AVAssetExportPreset1280x720) { exportSession in
      guard let session = exportSession else {
        return
      }
      
      switch session.status {
      case .unknown:
        break
      case .waiting:
        break
      case .exporting:
        break
      case .completed:
        guard let compressedData = try? Data(contentsOf: compressedURL) else {
          return
        }
        
        print("File size after compression: \(Double(compressedData.count / 1048576)) mb")
      case .failed:
        break
      case .cancelled:
        break
      @unknown default:
        break
      }
    }
  }
  func compressVideo(inputURL: URL,
                     outputURL: URL,
                     preset: String,
                     handler:@escaping (_ exportSession: AVAssetExportSession?) -> Void) {
    let urlAsset = AVURLAsset(url: inputURL, options: nil)
    guard let exportSession = AVAssetExportSession(asset: urlAsset,
                                                   presetName: preset) else {
      handler(nil)
      
      return
    }
    
    exportSession.outputURL = outputURL
    exportSession.outputFileType = .mp4
    exportSession.exportAsynchronously {
      handler(exportSession)
    }
  }
}
