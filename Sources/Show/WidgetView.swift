import SwiftUI
import ShowImage

struct WidgetView<Image: ImageDescription>: View {
  var images: [Image]
  var store: ImageStore
  var indexDisplayMode: PageTabViewStyle.IndexDisplayMode = .automatic
  
  @Binding var currentImage: Image
  
  var body: some View {
    TabView(selection: $currentImage) {
      ForEach(images) { image in
        ZStack {
          Color.black
          ImageView(id: image.imageId, store: ImageStore.mock)
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

struct DemoWidhet: View {
  @State var state = "B"
  
  var body: some View {
    VStack {
      Text(state)
      WidgetView(images: ["A", "B", "C", "D", "E"], store: .mock, currentImage: $state)
    }
  }
}

struct WidgetView_Previews: PreviewProvider {
  static var previews: some View {
    DemoWidhet()
  }
}
