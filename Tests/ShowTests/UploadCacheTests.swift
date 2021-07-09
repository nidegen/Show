import XCTest
@testable import Show

final class UploadCacheTests: XCTestCase {
  var cache = UploadCache()
  func testCacheStore() {
    cache.clearUploadCacheFolder()
    guard let imageURL = URL(string: "https://source.unsplash.com/random") else { XCTFail(); return }
    guard let imageData = try? Data(contentsOf: imageURL) else { XCTFail(); return }
    cache.store(image: imageData, metaData: ["Test": "jätte Bra"])
    let ids = cache.loadCachedUploads()
    
    XCTAssert(ids.count == 1)
    XCTAssert(cache.imageURLs.count == 1)
    XCTAssert(cache.metadataURLs.count == 1)
    
    let loaded = cache.loadImageData(forId: ids.first!)
    
    XCTAssert(loaded == imageData)
    
    cache.deleteItems(withId: ids.first!)
    let new = cache.loadCachedUploads()
    XCTAssert(new.isEmpty)
  }
}
