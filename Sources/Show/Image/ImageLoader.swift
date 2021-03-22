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
  @Published var image: UIImage?
  
  func load(id: Id, store: ImageStore, sizeClass: ImageSizeClass = .original) {
    
    store.image(forId: id, sizeClass: sizeClass) { image in
      if let image = image {
        self.image = image
      } else {
        self.image = store.cache.getImage(forId: id, notLargerThan: sizeClass)
      }
    }
  }
}
