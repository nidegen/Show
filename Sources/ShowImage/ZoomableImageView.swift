import SwiftUI

public struct ZoomImageView: UIViewRepresentable {
  var id: Id
  var store: ImageStore
  
  public init(id: Id, imageStore: ImageStore) {
    self.id = id
    store = imageStore
  }
  
  public func makeUIView(context: Context) -> UIScrollView {
    // set up the UIScrollView
    let scrollView = UIScrollView()
    scrollView.delegate = context.coordinator  // for viewForZooming(in:)
    scrollView.maximumZoomScale = context.coordinator.mazZoom
    scrollView.minimumZoomScale = context.coordinator.minZoom
    scrollView.bouncesZoom = true
    
    // create a UIHostingController to hold our SwiftUI content
    let imageView = context.coordinator.imageView
    imageView.translatesAutoresizingMaskIntoConstraints = true
    imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    imageView.frame = scrollView.bounds
    scrollView.addSubview(imageView)
    
    return scrollView
  }
  
  public func makeCoordinator() -> Coordinator {
    return Coordinator(image: id, imageStore: store)
  }
  
  public func updateUIView(_ uiView: UIScrollView, context: Context) {
  }
  
  // MARK: - Coordinator
  
  public class Coordinator: NSObject, UIScrollViewDelegate {
    let imageView: UIImageView = UIImageView(frame: .zero)
    let imageStore: ImageStore
    
    var mazZoom: CGFloat = 20
    var minZoom: CGFloat = 1
    
    init(image id: Id, imageStore: ImageStore) {
      self.imageStore = imageStore
      super.init()
      
      imageStore.image(forId: id) { image in
        self.imageView.image = image
        self.imageView.contentMode = .scaleAspectFit
      }
    }
    
//    @IBAction func userDoubleTappedScrollview(recognizer:  UITapGestureRecognizer) {
//      if (zoomScale > minZoom) {
//        setZoomScale(minZoom, animated: true)
//      }
//      else {
//        //(I divide by 3.0 since I don't wan't to zoom to the max upon the double tap)
//        let zoomRect = zoomRectForScale(scale: mazZoom / 3.0, center: recognizer.location(in: recognizer.view))
//         zoom(to: zoomRect, animated: true)
//      }
//    }

    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      return imageView
    }
  }
}
