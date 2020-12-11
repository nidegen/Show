import SwiftUI

public struct ZoomableImageView: UIViewRepresentable {
  @ObservedObject private var imageLoader: ImageLoader
  
  
  public init(id: Id?, store: ImageStore) {
    imageLoader = ImageLoader(store: store)
    id.map {
      imageLoader.load(id: $0)
    }
  }
  
  
  
  public func makeUIView(context: UIViewRepresentableContext<ZoomableImageView>) -> ImageZoomView {
    ImageZoomView(frame: CGRect(x: 0, y: 0, width: 300, height: 400),
                  image: imageLoader.downloadedImage ?? UIImage(systemName: "photo")!)
  }
  
  public func updateUIView(_ uiView: ImageZoomView, context: UIViewRepresentableContext<ZoomableImageView>) {
    uiView.imageView.image = imageLoader.downloadedImage
    uiView.imageView.frame = uiView.bounds
  }
}


public class ImageZoomView: UIScrollView, UIScrollViewDelegate {
  
  var imageView: UIImageView!
  var gestureRecognizer: UITapGestureRecognizer!
  
  public convenience init(frame: CGRect, image: UIImage) {
    self.init(frame: frame)
    self.showsVerticalScrollIndicator =  false
    self.showsHorizontalScrollIndicator =  false
    
    // Creates the image view and adds it as a subview to the scroll view
    imageView = UIImageView(image: image)
    
    imageView.contentMode = .scaleAspectFill
    addSubview(imageView)
    
    setupScrollView(image: image)
    setupGestureRecognizer()
  }
  
  // Sets the scroll view delegate and zoom scale limits.
  // Change the `maximumZoomScale` to allow zooming more than 2x.
  func setupScrollView(image: UIImage) {
    delegate = self
    
    minimumZoomScale = 1.0
    maximumZoomScale = 2.0
  }
  
  // Sets up the gesture recognizer that receives double taps to auto-zoom
  func setupGestureRecognizer() {
    gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
    gestureRecognizer.numberOfTapsRequired = 2
    addGestureRecognizer(gestureRecognizer)
  }
  
  // Handles a double tap by either resetting the zoom or zooming to where was tapped
  @IBAction func handleDoubleTap() {
    if zoomScale == 1 {
      zoom(to: zoomRectForScale(maximumZoomScale, center: gestureRecognizer.location(in: gestureRecognizer.view)), animated: true)
    } else {
      setZoomScale(1, animated: true)
    }
  }
  
  // Calculates the zoom rectangle for the scale
  func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
    var zoomRect = CGRect.zero
    zoomRect.size.height = imageView.frame.size.height / scale
    zoomRect.size.width = imageView.frame.size.width / scale
    let newCenter = convert(center, from: imageView)
    zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
    zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
    return zoomRect
  }
  
  // Tell the scroll view delegate which view to use for zooming and scrolling
  public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}
