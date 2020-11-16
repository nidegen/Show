import SwiftUI
import ShowVideo

struct SwiftUIView: View {
  var body: some View {
    VStack {
      Spacer()
      VideoView(.testVideo)
      Spacer()
    }
  }
}

struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    SwiftUIView()
  }
}
