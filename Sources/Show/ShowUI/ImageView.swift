import SwiftUI

public struct ImageView: View {
  @StateObject private var imageLoader = ImageLoader()
  
  var placeholder: AnyView?
  
  var id: Id?
  var format: ImageFormat
  var store: ImageStore

  public init(
    id: Id?,
    format: ImageFormat = .preview,
    store: ImageStore,
    placeholder: AnyView? = nil
  ) {
    self.id = id
    self.format = format
    self.store = store
    self.placeholder = placeholder
  }
  
  @ViewBuilder
  public var body: some View {
    Group {
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
    .task {
      if let id {
        await imageLoader.load(id: id, store: store, format: format)
      }
    }
    .id(id)
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
        .foregroundColor(.white.opacity(0.5))
      if id != nil {
        ProgressView()
      }
    }
  }
}

struct ImageView_Previews: PreviewProvider {
  static var previews: some View {
    ImageView(id: "nbl", store: ImageStore(server: MockServer()))
      .ignoresSafeArea()
//      .colorScheme(.dark)
  }
}
