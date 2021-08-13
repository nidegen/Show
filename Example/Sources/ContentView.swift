//
//  ContentView.swift
//  Test
//
//  Created by Nicolas Degen on 11.11.20.
//

import SwiftUI
import Show

struct ContentView: View {
  @State var image = "gear"
  
  var options = ["gear", "person", "swift"]
  
  var body: some View {
    VStack {
      GalleryView(images: ["gear", "person", "swift"], currentImage: $image, store: .mock)
      Text(image)
      ZoomImageView(id: image, imageStore: .mock) {
        image = options[Int.random(in: 0...2)]
      }
      Button("next") {
        image = options[Int.random(in: 0...2)]
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
