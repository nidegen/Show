//
//  ImageServer.swift
//  Echo
//
//  Created by Nicolas Degen on 19.09.20.
//  Copyright © 2020 Echo Labs AG. All rights reserved.
//

import Foundation
import UIKit

public protocol ImageServer {
  func image(forId id: Id, withSize size: ImageSizeClass, completion: @escaping (UIImage?)->())
  
  @discardableResult
  func uploadNewImage(_ photo: UIImage, id: Id,
                      maxResolution: CGFloat?,
                      compression: CGFloat,
                      completion: ((Id?)->())?) -> Id
  
  @discardableResult
  func uploadNewImage(fromURL photoURL: URL,
                      id: Id,
                      completion: ((Id?)->())?) -> Id
  
  func deleteImage(withId id: Id)
}
