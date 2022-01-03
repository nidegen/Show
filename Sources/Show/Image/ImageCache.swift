//
//  ImageCache.swift
//  Echo
//
//  Created by Nicolas Degen on 06.09.20.
//  Copyright © 2020 Echo Labs AG. All rights reserved.
//

import Foundation

public class ImageCache {
  private let fileManager = FileManager.default
  let cache = NSCache<NSString, UIImage>()
  
  public init() {
    cache.countLimit = 30
  }
  
  
  public func deleteCache() {
    guard let cacheURL = fileManager.baseImageCacheUrl else { return }
    try? fileManager.removeItem(atPath: cacheURL.path)
  }
  
  public func deleteCache(of ids: [String]) {
    for id in ids {
      guard let cacheURL = fileManager.cachedImageDirUrl(forId: id) else { continue }
      try? fileManager.removeItem(atPath: cacheURL.path)
    }
  }
  
  @discardableResult
  public func getImages(ids: [Id], format: ImageFormat = .original) -> [UIImage] {
    ids.compactMap { id in getImage(forId: id, format: format) }
  }
  
  public func getMemoryCached(_ request: ImageRequest) -> UIImage? {
    for format in request.formats {
      if let cachedVersion = cache.object(forKey: (request.imageId + format.rawValue) as NSString) {
        return cachedVersion
      }
    }
    return nil
  }
  
  public func getImage(forId id: Id, format: ImageFormat = .original) -> UIImage? {
    if let cachedVersion = cache.object(forKey: (id + format.rawValue) as NSString) {
        return cachedVersion
    }
    guard let url = fileManager.cachedImageUrl(forId: id, format: format) else { return nil }
    let pngUrl = url.appendingPathExtension("png")
    let jpgUrl = url.appendingPathExtension("jpg")
    var image: UIImage?
    if fileManager.fileExists(atPath: pngUrl.path) {
      image = UIImage(contentsOfFile: pngUrl.path)
    } else if fileManager.fileExists(atPath: jpgUrl.path) {
      image = UIImage(contentsOfFile: jpgUrl.path)
    }
    image.map {
      cache.setObject($0, forKey: (id + format.rawValue) as NSString)
    }
    return image
  }
  
  public func getImage(forId id: Id, notLargerThan maximumFormat: ImageFormat) -> UIImage? {
    if maximumFormat == .thumbnailSquared {
      return getImage(forId: id, format: .thumbnailSquared)
    }
    return getImage(forId: id, format: maximumFormat) ?? getImage(forId: id, largerThan: maximumFormat.nextSmaller)
  }
  
  public func getImage(forId id: Id, largerThan minimumFormat: ImageFormat) -> UIImage? {
    if minimumFormat == .original {
      return getImage(forId: id, format: .original)
    }
    return getImage(forId: id, format: minimumFormat) ?? getImage(forId: id, largerThan: minimumFormat.nextLarger)
  }
  
  public func setImage(_ image: UIImage, forId id: Id, format: ImageFormat = .original) {
    cache.setObject(image, forKey: (id + format.rawValue) as NSString)
    guard var url = self.fileManager.cachedImageUrl(forId: id, format: format) else { return }
    url.appendPathExtension("jpg")
    do {
      try fileManager.createDirectory(atPath: url.deletingLastPathComponent().path, withIntermediateDirectories: true, attributes: nil)
      try image.jpegData(compressionQuality: 1)?.write(to: url)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  public func setImage(_ image: URL, forId id: Id, format: ImageFormat = .original) {
    cache.setObject(image, forKey: (id + format.rawValue) as NSString)
    guard var url = self.fileManager.cachedImageUrl(forId: id, format: format) else { return }
    url.appendPathExtension("jpg")
    do {
      try fileManager.createDirectory(atPath: url.deletingLastPathComponent().path, withIntermediateDirectories: true, attributes: nil)
      try image.jpegData(compressionQuality: 1)?.write(to: url)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  public func setImage(_ imageData: Data, forId id: Id, format: ImageFormat = .original) {
    if let image = UIImage(data: imageData) {
      cache.setObject(image, forKey: (id + format.rawValue) as NSString)
    }
    guard var url = self.fileManager.cachedImageUrl(forId: id, format: format) else { return }
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
  
  func cachedImageUrl(forId id: Id, format: ImageFormat = .original) -> URL? {
    cachedImageDirUrl(forId: id)?.appendingPathComponent(format.rawValue)
  }
}

enum ImageHeaderData: UInt8 {
  case png = 0x89
  case jpeg = 0xFF
  case gif = 0x47
  case tiff01 = 0x49
  case tiff02 = 0x4D
  
  var imageFormat: ImageFileFormat {
    switch self {
    case .jpeg:
      return ImageFileFormat.jpeg
    case .png:
      return ImageFileFormat.png
    case .gif:
      return ImageFileFormat.gif
    case .tiff01:
      return ImageFileFormat.tiff
    case .tiff02:
      return ImageFileFormat.tiff
    }
  }
}

enum ImageFileFormat: String {
  case png, jpeg, gif, tiff
}

extension Data {
  var imageFormat: ImageFileFormat? {
    var buffer = [UInt8](repeating: 0, count: 1)
    let nsData = self as NSData
    nsData.getBytes(&buffer, range: NSRange(location: 0,length: 1))
    return ImageHeaderData(rawValue: buffer[0])?.imageFormat ?? nil
  }
}
