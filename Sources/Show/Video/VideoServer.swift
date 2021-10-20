import Foundation

public protocol VideoServer {
  func downloadVideo(forId id: Id, toDirectory dirUrl: URL, completion: @escaping (URL?)->())
  
  func uploadVideo(videoURL: URL, id: Id,
                   completion: ((Id?)->())?)
  
  func deleteVideo(withId id: Id)
}
