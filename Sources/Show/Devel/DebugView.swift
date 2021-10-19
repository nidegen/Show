import SwiftUI

// This is a debug View as SwiftUI Previews only work in a target of the same name as the package
struct DebugView: View {
  var body: some View {
    VStack {
      Spacer()
      ImageView(id: "test", store: .mock)
        .padding()
      Spacer()
    }
  }
}

struct DebugView_Previews: PreviewProvider {
  static var previews: some View {
    DebugView()
  }
}
