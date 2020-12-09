import SwiftUI
import ShowImage

struct GalleryView<Image: ImageDescription>: View {
  var images: [Image]
  
  @Binding var currentImage: Image
  
  var body: some View {
    TabView(selection: $currentImage) {
      ForEach(images) { image in
        ZStack {
          Color.black
          ImageView(id: image.imageId)
        }
      }
    }
    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
  }
}

struct GalleryView_Previews: PreviewProvider {
  @State static var state = "b"
  static var previews: some View {
    GalleryView(images: ["a1", "b1", "c1"], currentImage: $state)
  }
}
