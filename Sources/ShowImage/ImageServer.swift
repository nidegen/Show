//
//  ImageServer.swift
//  Echo
//
//  Created by Nicolas Degen on 19.09.20.
//  Copyright © 2020 Echo Labs AG. All rights reserved.
//

import Foundation
import UIKit

public struct UploadTask {
  var image: URL
  var priority: Int
}

public protocol UploadObserver: class { // Not used yet, will be used for progress tracking
  var id: Id { get }
  var progress: Float { get }
  func pause()
  func resume()
  var completion: Completion? { get set }
}

public typealias Completion = (Result<Id,Error>) -> ()

public protocol ImageServer {
  func image(forId id: Id, withSize size: ImageSizeClass, completion: @escaping (UIImage?)->())
  
  @discardableResult
  func uploadNewImage(_ photo: UIImage, id: Id,
                      maxResolution: CGFloat?,
                      compression: CGFloat,
                      completion: Completion?) -> UploadObserver
  
  @discardableResult
  func uploadNewImage(fromURL photoURL: URL,
                      id: Id,
                      completion: Completion?) -> UploadObserver
  
  func deleteImage(withId id: Id)
}
