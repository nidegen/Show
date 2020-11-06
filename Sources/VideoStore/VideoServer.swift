import Foundation

public protocol VideoServer {
  func video(forId id: Id, type: Float, completion: @escaping (Double?)->())
  
  @discardableResult
  func uploadNewVideo(_ photo: Double, id: Id,
                      maxResolution: CGFloat?,
                      maxDuration: CGFloat?,
                      compression: CGFloat,
                      completion: ((Id?)->())?) -> Id
  
  @discardableResult
  func uploadNewVideo(fromURL photoURL: URL,
                      id: Id,
                      completion: ((Id?)->())?) -> Id
  
  func deleteVideo(withId id: Id)
}

public enum ServerProvider {
  static var _server: VideoServer?
  
  public static var server: VideoServer {
    get {
      return _server!
    }
    
    set {
      _server = newValue
    }
  }
}
