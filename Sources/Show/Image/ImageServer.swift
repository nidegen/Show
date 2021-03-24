//
//  ImageServer.swift
//  Echo
//
//  Created by Nicolas Degen on 19.09.20.
//  Copyright © 2020 Echo Labs AG. All rights reserved.
//

import Foundation
import UIKit

public typealias Completion = (Result<Id,Error>) -> ()

public protocol ImageServer {
  func image(forId id: Id, withSize size: ImageSizeClass, completion: @escaping (UIImage?)->())
  
  func uploadNewImage(_ photo: UIImage, id: Id,
                      maxResolution: CGFloat?,
                      compression: CGFloat,
                      completion: Completion?) -> UploadTask
  
  func uploadNewImage(fromURL photoURL: URL,
                      id: Id,
                      completion: Completion?) -> UploadTask
  
  func deleteImage(withId id: Id)
}
