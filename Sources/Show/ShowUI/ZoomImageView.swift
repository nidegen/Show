import SwiftUI

public struct ZoomImageView: UIViewRepresentable {
  var id: Id
  var store: ImageStore
  
  var maxZoom: CGFloat
  var minZoom: CGFloat
  
  var onTap: (()->())?
  
  public init(id: Id, imageStore: ImageStore = (.defaultStore ?? .mock),
              maxZoom: CGFloat = 20,
              minZoom: CGFloat = 1,
              onTap: (()->())? = nil) {
    self.id = id
    store = imageStore
    self.maxZoom = maxZoom
    self.minZoom = minZoom
    self.onTap = onTap
  }
  
  public func makeUIView(context: Context) -> UIScrollView {
    // set up the UIScrollView
    let scrollView = UIScrollView()
    scrollView.delegate = context.coordinator  // for viewForZooming(in:)
    scrollView.maximumZoomScale = context.coordinator.maxZoom
    scrollView.minimumZoomScale = context.coordinator.minZoom
    scrollView.bouncesZoom = true
    
    // create a UIHostingController to hold our SwiftUI content
    let imageView = context.coordinator.imageView
    imageView.translatesAutoresizingMaskIntoConstraints = true
    imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    imageView.frame = scrollView.bounds
    scrollView.addSubview(imageView)
    
    let doubleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleDoubleTap(recognizer:)))
    doubleTap.numberOfTapsRequired = 2
    doubleTap.numberOfTouchesRequired = 1
    scrollView.addGestureRecognizer(doubleTap)
    
    let singleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(recognizer:)))
    singleTap.numberOfTapsRequired = 1
    singleTap.numberOfTouchesRequired = 1
    singleTap.require(toFail: doubleTap)
    
    scrollView.addGestureRecognizer(singleTap)
    
    return scrollView
  }
  
  public func makeCoordinator() -> Coordinator {
    return Coordinator(image: id, imageStore: store, maxZoom: maxZoom, minZoom: minZoom, onTap: onTap)
  }
  
  public func updateUIView(_ uiView: UIScrollView, context: Context) {
    context.coordinator.id = self.id
    context.coordinator.scrollView = uiView
    uiView.zoomScale = 0
  }
  
  // MARK: - Coordinator
  
  public class Coordinator: NSObject, UIScrollViewDelegate {
    let imageView: UIImageView = UIImageView(frame: .zero)
    weak var scrollView: UIScrollView?
    
    var onTap: (()->())?

    let imageStore: ImageStore
    var id: Id {
      didSet {
        self.imageView.image = nil
        
        imageStore.image(forId: id) { image in
          self.imageView.image = image
        }
      }
    }
    
    var maxZoom: CGFloat
    var minZoom: CGFloat
    
    init(image id: Id, imageStore: ImageStore,
         maxZoom: CGFloat, minZoom: CGFloat,
         onTap: (()->())? = nil) {
      self.maxZoom = maxZoom
      self.minZoom = minZoom
      self.imageStore = imageStore
      self.onTap = onTap
      self.id = id
      super.init()
      self.imageView.contentMode = .scaleAspectFit
      
      imageStore.image(forId: id) { image in
        self.imageView.image = image
      }
    }
    
    @IBAction func handleTap(recognizer:  UITapGestureRecognizer) {
      onTap?()
    }
    
    @IBAction func handleDoubleTap(recognizer:  UITapGestureRecognizer) {
      guard  let scrollView = scrollView else {
        return
      }
      if (scrollView.zoomScale > scrollView.minimumZoomScale) {
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
      } else {
        //(I divide by 3.0 since I don't wan't to zoom to the max upon the double tap)
        let zoomRect = zoomRectForScale(scale: scrollView.maximumZoomScale / 3.0, center: recognizer.location(in: recognizer.view))
        scrollView.zoom(to: zoomRect, animated: true)
      }
    }
    
    func zoomRectForScale(scale : CGFloat, center : CGPoint) -> CGRect {
      var zoomRect = CGRect.zero
      zoomRect.size.height = imageView.frame.size.height / scale;
      zoomRect.size.width  = imageView.frame.size.width  / scale;
      let newCenter = imageView.convert(center, from: scrollView)
      zoomRect.origin.x = newCenter.x - ((zoomRect.size.width / 2.0));
      zoomRect.origin.y = newCenter.y - ((zoomRect.size.height / 2.0));
      return zoomRect;
    }

    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      return imageView
    }
  }
}
