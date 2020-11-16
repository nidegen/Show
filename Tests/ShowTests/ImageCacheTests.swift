import XCTest
@testable import ShowImage

final class ImageCacheTests: XCTestCase {
  var cache = ImageCache()
  func testStore() {
    guard let imageURL = URL(string: "https://source.unsplash.com/random") else { XCTFail(); return }
    guard let randomImage = try? UIImage(data: Data(contentsOf: imageURL)) else { XCTFail(); return }
    cache.setImage(randomImage, forId: "test")
    guard let cached = cache.getImage(forId: "test") else {
      XCTFail("no cached image")
      return
    }
    XCTAssert(cached == randomImage)
    
  }
}
