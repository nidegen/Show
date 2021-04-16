import SwiftUI

public struct ImageView: View {
  @StateObject private var imageLoader = ImageLoader()
  
  let store: ImageStore
  let id: Id?
  let sizeClass: ImageSizeClass
  public var placeholder: AnyView? = nil

  public init(id: Id?, sizeClass: ImageSizeClass = .original, store: ImageStore = (.defaultStore ?? .mock)) {
    self.id = id
    self.store = store
    self.sizeClass = sizeClass
  }
  
  @ViewBuilder
  public var body: some View {
    Group {
      if imageLoader.image != nil {
        SwiftUI.Image(uiImage: imageLoader.image!.withRenderingMode(.alwaysOriginal))
          .resizable()
          .aspectRatio(contentMode: .fill)
      } else {
        if let placeholder = placeholder {
          placeholder
        } else {
          defaultPlaceholder
        }
      }
    }
    .onAppear{
      id.map {
        imageLoader.load(id: $0, store: store, sizeClass: sizeClass)
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
      Color.black
      SwiftUI.Image(systemName: "photo")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .padding()
        .foregroundColor(.white)
    }
  }
}

struct ImageView_Previews: PreviewProvider {
  static var previews: some View {
    ImageView(id: "nbl")
  }
}
