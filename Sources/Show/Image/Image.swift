import Foundation
import UIKit.UIImage

class Image {
  var sizeClass: ImageSizeClass
  var image: UIImage
  
  init(image: UIImage) {
    self.image = image
    let imageSize = max(image.size.width, image.size.height)
    sizeClass = ImageSizeClass.sizeClass(for: imageSize)
  }
}
