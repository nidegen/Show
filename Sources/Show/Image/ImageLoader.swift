//
//  ImageLoader.swift
//  Echo
//
//  Created by Nicolas Degen on 18.09.20.
//  Copyright © 2020 Echo Labs AG. All rights reserved.
//

import Foundation

class ImageLoader: ObservableObject {
  @Published var downloadedImage: UIImage?
  let store: ImageStore
  let format: ImageFormat
  
  init(store: ImageStore, format: ImageFormat = .preview) {
    self.store = store
    self.format = format
  }
  
  func load(id: Id) {
    store.image(forId: id, format: format) { image in
      self.downloadedImage = image
    }
  }
}
