//
//  ImageLoader.swift
//  Echo
//
//  Created by Nicolas Degen on 18.09.20.
//  Copyright © 2020 Echo Labs AG. All rights reserved.
//

import Foundation
import UIKit

class ImageLoader: ObservableObject {
  @Published var downloadedImage: UIImage?
  var store: ImageStore
  
  init(store: ImageStore) {
    self.store = store
  }
  
  func load(id: Id) {
    store.image(forId: id, type: .original) { image in
      guard image != nil else { return }
      self.downloadedImage = image
    }
  }
}
