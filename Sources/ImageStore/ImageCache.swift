//
//  ImageCache.swift
//  Echo
//
//  Created by Nicolas Degen on 06.09.20.
//  Copyright © 2020 Echo Labs AG. All rights reserved.
//

import Foundation
import UIKit

public class ImageCache {
  public init() {}
  
  private let fileManager = FileManager.default
  let cache = NSCache<NSString, UIImage>()
  
  public func getImage(forId id: Id, minimalSize size: ImageSizeClass = .original) -> UIImage? {
    if let cachedVersion = cache.object(forKey: (id + size.rawValue) as NSString) {
        return cachedVersion
    }
    guard let url = fileManager.cachedImageUrl(forId: id, withSize: size) else { return nil }
    let pngUrl = url.appendingPathExtension("png")
    let jpgUrl = url.appendingPathExtension("jpg")
    if fileManager.fileExists(atPath: pngUrl.path) {
      return UIImage(contentsOfFile: pngUrl.path)
    } else if fileManager.fileExists(atPath: jpgUrl.path) {
      return UIImage(contentsOfFile: jpgUrl.path)
    } else {
      if size != size.nextLarger {
        return getImage(forId: id, minimalSize: size.nextLarger)
      } else {
        return nil
      }
    }
  }
  
  public func setImage(_ image: UIImage, forId id: Id, size: ImageSizeClass = .original) {
    cache.setObject(image, forKey: (id + size.rawValue) as NSString)
    guard var url = self.fileManager.cachedImageUrl(forId: id, withSize: size) else { return }
    url.appendPathExtension("jpg")
    do {
      try FileManager.default.createDirectory(atPath: url.deletingLastPathComponent().path, withIntermediateDirectories: true, attributes: nil)
      try image.jpegData(compressionQuality: 1)?.write(to: url)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  public func setImage(_ imageData: Data, forId id: Id, size: ImageSizeClass = .original) {
    if let image = UIImage(data: imageData) {
      cache.setObject(image, forKey: (id + size.rawValue) as NSString)
    }
    guard var url = self.fileManager.cachedImageUrl(forId: id, withSize: size) else { return }
    url.appendPathExtension(imageData.imageFormat?.rawValue ?? "jpg")
    
    do {
      try FileManager.default.createDirectory(atPath: url.deletingLastPathComponent().path, withIntermediateDirectories: true, attributes: nil)
      try imageData.write(to: url)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  public func deleteImage(withId id: Id) {
    guard let url = self.fileManager.cachedImageDirUrl(forId: id) else { return }
    
    try? fileManager.removeItem(at: url)
  }
}

extension FileManager {
  var baseImageCacheUrl: URL? {
    try? self.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      .appendingPathComponent("imageCache", isDirectory: true)
  }

  func cachedImageDirUrl(forId id: Id) -> URL? {
    baseImageCacheUrl?.appendingPathComponent(id, isDirectory: true)
  }
  
  func cachedImageUrl(forId id: Id, withSize size: ImageSizeClass = .original) -> URL? {
    cachedImageDirUrl(forId: id)?.appendingPathComponent(size.rawValue)
  }
}

enum ImageHeaderData: UInt8 {
  case png = 0x89
  case jpeg = 0xFF
  case gif = 0x47
  case tiff01 = 0x49
  case tiff02 = 0x4D
  
  var imageFormat: ImageFormat {
    switch self {
    case .jpeg:
      return ImageFormat.jpeg
    case .png:
      return ImageFormat.png
    case .gif:
      return ImageFormat.gif
    case .tiff01:
      return ImageFormat.tiff
    case .tiff02:
      return ImageFormat.tiff
    }
  }
}

enum ImageFormat: String {
  case png, jpeg, gif, tiff
}

extension Data {
  var imageFormat: ImageFormat? {
    var buffer = [UInt8](repeating: 0, count: 1)
    let nsData = self as NSData
    nsData.getBytes(&buffer, range: NSRange(location: 0,length: 1))
    return ImageHeaderData(rawValue: buffer[0])?.imageFormat ?? nil
  }
}
