import SwiftUI

public struct ImageView: View {
  @ObservedObject private var imageLoader: ImageLoader
  
  public var placeholder: AnyView?

  public init(id: Id?, format: ImageFormat = .preview, store: ImageStore) {
    imageLoader = ImageLoader(store: store, format: format)
    id.map {
      imageLoader.load(id: $0)
    }
  }
  
  @ViewBuilder
  public var body: some View {
    if let image = imageLoader.downloadedImage {
      #if os(iOS)
      SwiftUI.Image(uiImage: image.withRenderingMode(.alwaysOriginal))
        .resizable()
        .aspectRatio(contentMode: .fill)
      #else
      SwiftUI.Image(uiImage: image)
        .resizable()
        .aspectRatio(contentMode: .fill)
      #endif
    } else {
      if let placeholder = placeholder {
        placeholder
      } else {
        defaultPlaceholder
      }
    }
  }
  
  public func placeholder<Content: View>(@ViewBuilder _ content: () -> Content) -> ImageView {
    let v = content()
    var result = self
    result.placeholder = AnyView(v)
    return result
  }
  
  var defaultPlaceholder: some View {
    ZStack {
      Color.gray
      SwiftUI.Image(systemName: "photo")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .padding()
        .foregroundColor(.white)
      ProgressView()
    }
  }
}

struct ImageView_Previews: PreviewProvider {
  static var previews: some View {
    ImageView(id: "nbl", store: ImageStore(server: MockServer()))
  }
}
