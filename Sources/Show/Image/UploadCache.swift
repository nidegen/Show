import Foundation

public class UploadCache {
  let fileManager = FileManager.default
  
  var imageURLs = [String]()
  var metadataURLs = [String]()
  
  
  public func loadCachedUploads() -> [String] {
    guard let fileURLs = try? fileManager.contentsOfDirectory(at: baseUploadCacheUrl, includingPropertiesForKeys: nil) else { return [] }
    imageURLs.removeAll()
    metadataURLs.removeAll()
    
    for file in fileURLs {
      if file.filetype == "jpg" {
        imageURLs.append(file.filename)
      } else if file.filetype == "json" {
        metadataURLs.append(file.filename)
      }
    }
//    let images = fileURLs.filter { $0.pathExtension == "jpg" }
//    let metadata = fileURLs.filter { $0.pathExtension == "json" }
    return imageURLs
  }
  
  public func clearUploadCacheFolder() {
    try? FileManager.default.removeItem(at: baseUploadCacheUrl)
  }
  public func deleteItems(withId id: String) {
    let imageURL = baseUploadCacheUrl.appendingPathComponent(id).appendingPathExtension("jpg")
    let dataURL = baseUploadCacheUrl.appendingPathComponent(id).appendingPathExtension("json")
    try? FileManager.default.removeItem(at: imageURL)
    try? FileManager.default.removeItem(at: dataURL)
  }
  
  public func loadMetadata(forId id: String) -> [String: Any] {
    let dataURL = baseUploadCacheUrl.appendingPathComponent(id).appendingPathExtension("json")
    return loadMetadata(atURL: dataURL)
  }
  
  func loadMetadata(atURL url: URL) -> [String: Any] {
    if let data = try? Data(contentsOf: url) {
      do {
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
      } catch {
        print(error.localizedDescription)
      }
    }
    return [:]
  }
  
  public func loadImageData(forId id: String) -> Data? {
    let imageURL = baseUploadCacheUrl.appendingPathComponent(id).appendingPathExtension("jpg")
    return loadImageData(atURL: imageURL)
  }
  
  public func loadImageData(atURL url: URL) -> Data? {
    return try? Data(contentsOf: url)
  }
  
  public func store(image: Data, metaData: [String: Any]) {
    let id = UUID().uuidString
    
    let imageURL = baseUploadCacheUrl.appendingPathComponent(id).appendingPathExtension("jpg")
    let dataURL = baseUploadCacheUrl.appendingPathComponent(id).appendingPathExtension("json")
    do {
      try FileManager.default.createDirectory(atPath: imageURL.deletingLastPathComponent().path, withIntermediateDirectories: true, attributes: nil)
      try image.write(to: imageURL)
    } catch {
      print(error.localizedDescription)
    }
    
    if let jsonData = try? JSONSerialization.data(withJSONObject: metaData) {
      do {
        try FileManager.default.createDirectory(atPath: imageURL.deletingLastPathComponent().path, withIntermediateDirectories: true, attributes: nil)
        try jsonData.write(to: dataURL)
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  public var baseUploadCacheUrl: URL {
    NSURL.fileURL(withPath: NSTemporaryDirectory()).appendingPathComponent("UploadCache")
  }
}

extension URL {
  var filename: String {
    String(self.lastPathComponent.dropLast(self.pathExtension.count + 1))
  }
  
  var filetype: String {
    self.pathExtension
  }
}
