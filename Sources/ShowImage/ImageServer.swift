//
//  ImageServer.swift
//  Echo
//
//  Created by Nicolas Degen on 19.09.20.
//  Copyright © 2020 Echo Labs AG. All rights reserved.
//

import Foundation
import UIKit

protocol UploadObserver { // Not used yet, will be used for progress tracking
  func progressUpdate(progress: Float)
}

public typealias Completion = (Result<Id,Error>) -> ()

public protocol ImageServer {
  func image(forId id: Id, withSize size: ImageSizeClass, completion: @escaping (UIImage?)->())
  
  @discardableResult
  func uploadNewImage(_ photo: UIImage, id: Id,
                      maxResolution: CGFloat?,
                      compression: CGFloat,
                      completion: Completion?) -> Id
  
  @discardableResult
  func uploadNewImage(fromURL photoURL: URL,
                      id: Id,
                      completion: Completion?) -> Id
  
  func deleteImage(withId id: Id)
}
