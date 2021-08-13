import SwiftUI

public struct UploadBanner: View {
  @ObservedObject var uploadObserver: UploadObserver
  
  public var body: some View {
    HStack {
      SwiftUI.Image(systemName: "arrow.up.circle")
        .font(.largeTitle)
        .foregroundColor(.accentColor)
        .padding()
      VStack {
        Text("Uploading Images...")
        ProgressView(value: uploadObserver.totalProgress)
      }
      .padding()
    }
    .background(
      BlurView(style: .systemChromeMaterial)
        .clipShape(
          Capsule())
        .shadow(color: Color(.black).opacity(0.16), radius: 12, x: 0, y: 5)
    )
  }
}
struct UploadBanner_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      HStack {
        Color.black
        Color.red
      }
      UploadBanner(uploadObserver: UploadObserver())
    }
    .environment(\.colorScheme, .light)
    
    HStack {
      Color.black
      Color.red
    }.uploadBanner(isPresented: .constant(true), observer: UploadObserver())
    
    .environment(\.colorScheme, .dark)
  }
}

public extension View {
  func uploadBanner(
    isPresented: Binding<Bool>,
    observer: UploadObserver
  ) -> some View {
    ZStack(alignment: .top) {
      self
      
      if isPresented.wrappedValue {
        UploadBanner(uploadObserver: observer)
          .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
          .onTapGesture {
            withAnimation {
              isPresented.wrappedValue = false
            }
          }
//          .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//              withAnimation {
//                isPresented.wrappedValue = false
//              }
//            }
//          }
          .zIndex(1)
          .padding()
      }
    }
  }
}
