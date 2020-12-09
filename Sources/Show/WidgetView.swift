import SwiftUI
import ShowImage

struct WidgetView<Image: ImageDescription>: View {
  var images: [Image]
  var indexDisplayMode: PageTabViewStyle.IndexDisplayMode = .automatic
  
  @Binding var currentImage: Image
  
  var body: some View {
    TabView(selection: $currentImage) {
      ForEach(images) { image in
        ZStack {
          Color.black
          ImageView(id: image.imageId)
            .frame(width: UIScreen.main.bounds.width, height: 200)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
        .tag(image)
      }
      .padding(.all, 10)
    }
    .frame(width: UIScreen.main.bounds.width, height: 200)
    .tabViewStyle(PageTabViewStyle(indexDisplayMode: indexDisplayMode))
  }
}

struct WidgetView_Previews: PreviewProvider {
  @State static var state = "B"
  
  static var previews: some View {
    VStack {
      Text(state)
      WidgetView(images: ["A", "B", "C", "D", "E"], currentImage: $state)
    }
  }
}
