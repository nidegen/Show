import SwiftUI

public struct GalleryView<Image: ImageDescription>: View {
  public init(images: [Image], currentImage: Binding<Image>, store: ImageStore) {
    self.images = images
    self.store = store
    self._currentImage = currentImage
  }
  
  var images: [Image]
  var store: ImageStore
  
  @Binding var currentImage: Image
  
  
  public var body: some View {
    TabView(selection: $currentImage) {
      ForEach(images) { image in
        ZStack {
          Color.black
          ZoomImageView(id: image.imageId, imageStore: ImageStore.mock)
        }
      }
    }
    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
  }
}

struct GalleryView_Previews: PreviewProvider {
  @State static var image = "a1"
  static var previews: some View {
    VStack {
      GalleryView(images: ["a1", "b1", "c1"], currentImage: $image, store: .mock)
      Text(image)
    }
  }
}
