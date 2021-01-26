//
//  ContentView.swift
//  Test
//
//  Created by Nicolas Degen on 11.11.20.
//

import SwiftUI
import ShowImage
import Show

struct ContentView: View {
  @State var image = "a1"
  var body: some View {
    VStack {
      GalleryView(images: ["a1", "b1", "c1"], currentImage: $image, store: .mock)
      Text(image)
    }
//    ZoomImageView(id: "test", imageStore: .mock)
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
