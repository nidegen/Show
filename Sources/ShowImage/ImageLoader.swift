//
//  ImageLoader.swift
//  Echo
//
//  Created by Nicolas Degen on 18.09.20.
//  Copyright © 2020 Echo Labs AG. All rights reserved.
//

import Foundation
import UIKit
import Tools

class ImageLoader: ObservableObject {
  @Published var downloadedImage: UIImage?
  let store: ImageStore
  let sizeClass: ImageSizeClass
  
  init(store: ImageStore, sizeClass: ImageSizeClass = .original) {
    self.store = store
    self.sizeClass = sizeClass
  }
  
  func load(id: Id) {
    store.image(forId: id, sizeClass: sizeClass) { image in
      DispatchQueue.main.async {
        self.downloadedImage = image
      }
    }
  }
}
