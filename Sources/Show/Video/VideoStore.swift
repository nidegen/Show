import Foundation

public final class VideoStore {
  public var server: VideoServer
  
  private let fileManager = FileManager.default
  
  public init(server: VideoServer) {
    self.server = server
  }
  
  public func video(forId id: Id, completion: @escaping (Video?)->()) {
    guard let dirUrl = fileManager.cachedVideoeUrl(forId: id) else {
      completion(nil)
      return
    }
    server.downloadVideo(forId: id, toDirectory: dirUrl) { url in
      guard let localUrl = url else {
        completion(nil)
        return
      }
      let video = Video(id: id, localURL: localUrl)
      video.localURL.getVideoThumbnail { image in
        video.thumbnail = image
      }
      completion(video)
    }
  }
  
  public func uploadNewVideo(_ video: Video,
                             completion: ((Id?)->())?) {
    server.uploadVideo(videoURL: video.localURL, id: video.id, completion: completion)
  }
  
  public func deleteVideo(withId id: Id) {
    server.deleteVideo(withId: id)
  }
}

extension FileManager {
  var baseVideoCacheUrl: URL? {
    try? self.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      .appendingPathComponent("videoCache", isDirectory: true)
  }
  
  func cachedVideoDirUrl(forId id: Id) -> URL? {
    baseVideoCacheUrl?.appendingPathComponent(id, isDirectory: true)
  }
  
  func cachedVideoeUrl(forId id: Id) -> URL? {
    cachedVideoDirUrl(forId: id)?.appendingPathComponent("original")
  }
}
