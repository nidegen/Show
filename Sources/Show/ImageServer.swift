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
  func image(forId id: Id, type: ImageSizeClass, completion: @escaping (UIImage?)->())
  
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

public enum ServerProvider {
  static var _server: ImageServer?
  
  public static var server: ImageServer {
    get {
      return _server!
    }
    
    set {
      _server = newValue
    }
  }
}
