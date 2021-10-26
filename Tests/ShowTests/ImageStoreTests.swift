import XCTest
import UIKit
@testable import Show

final class ImageStoreTests: XCTestCase {
  var store = ImageStore(server: MockServer())
  
  override func setUp() {
    guard let imageURL = URL(string: "https://source.unsplash.com/random"),
          let randomImage = try? UIImage(data: Data(contentsOf: imageURL)) else { XCTFail(); return }
    store.uploadNewImage(randomImage, id: "testImage")
  }
  
  func testStore() {
    var expectations: [XCTestExpectation] = []
    for format in ImageFormat.allCases {
      expectations += [testImageFormat(format: format)]
    }
    wait(for: expectations, timeout: 2.0)
    for format in ImageFormat.allCases {
      testFormatCached(format: format)
    }
  }
  
  func testFormatCached(format: ImageFormat) {
    guard let img = store.cache.getImage(forId: "test", format: format) else { return }
    XCTAssertLessThanOrEqual(img.minSize, format.maxSmallerResolution)
  }
  
  func testImageFormat(format: ImageFormat) -> XCTestExpectation {
    let expectation = XCTestExpectation(description: "Test image getter for \(format.rawValue)")
    store.image(forId: "test", format: format) { image in
      if let image = image {
        XCTAssertLessThanOrEqual(image.minSize, format.maxSmallerResolution)
      }
      expectation.fulfill()
    }
    return expectation
  }
}
