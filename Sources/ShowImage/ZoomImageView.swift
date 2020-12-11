import SwiftUI

public struct ZoomImageView: View {
  public init(id: Id?, store: ImageStore) {
    self.id = id
    self.store = store
  }
  
  @State private var currentZoom: CGFloat = 0
  @State private var finalZoom: CGFloat = 1
  
  var id: String?
  var store: ImageStore
  
  public var body: some View {
    ImageView(id: id, store: store)
      .scaleEffect(finalZoom + currentZoom)
      .gesture(
        MagnificationGesture()
          .onChanged { zoom in
            self.currentZoom = zoom - 1
          }
          .onEnded { zoom in
            self.finalZoom += self.currentZoom
            self.currentZoom = 0
          }
      )
  }
}

struct ZoomImageView_Previews: PreviewProvider {
  static var previews: some View {
    ZoomImageView(id: "rest", store: .mock)
  }
}
