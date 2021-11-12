import Photos

public extension PHAsset {
  func requestImage(withSize size: CGSize = CGSize(width: 300, height: 300), contentMode: PHImageContentMode = .default) -> UIImage? {
    let manager = PHImageManager.default()
    let option = PHImageRequestOptions()
    var thumbnail: UIImage?
    option.isSynchronous = true
    manager.requestImage(for: self, targetSize: size, contentMode: contentMode, options: option, resultHandler: { (result, info) -> Void in
      thumbnail = result
    })
    return thumbnail
  }

  var squareThumbnail: UIImage? { requestImage(contentMode: .aspectFill) }
}
