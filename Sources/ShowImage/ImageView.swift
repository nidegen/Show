//
//  ImageView.swift
//  Echo
//
//  Created by Nicolas Degen on 18.09.20.
//  Copyright © 2020 Echo Labs AG. All rights reserved.
//

import SwiftUI

public struct ImageView: View {
  @ObservedObject private var imageLoader: ImageLoader
  
  public var placeholder: AnyView?

  public init(id: Id?, store: ImageStore) {
    imageLoader = ImageLoader(store: store)
    id.map {
      imageLoader.load(id: $0)
    }
  }
  
  @ViewBuilder
  public var body: some View {
    if imageLoader.downloadedImage != nil {
      Image(uiImage: imageLoader.downloadedImage!.withRenderingMode(.alwaysOriginal))
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
  
  public func placeholder<Content: View>(@ViewBuilder _ content: () -> Content) -> ImageView {
    let v = content()
    var result = self
    result.placeholder = AnyView(v)
    return result
  }
  
  var defaultPlaceholder: some View {
    ZStack {
      Color.black
      Image(systemName: "photo")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .padding()
    }
  }
}

struct EchoImageView_Previews: PreviewProvider {
  static var previews: some View {
    ImageView(id: "nbl", store: ImageStore(server: MockServer()))
  }
}
