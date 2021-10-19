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
    for size in ImageSizeClass.allCases {
      expectations += [testSizeClass(sizeClass: size)]
    }
    wait(for: expectations, timeout: 2.0)
    for size in ImageSizeClass.allCases {
      testSizeClassCached(sizeClass: size)
    }
  }
  
  func testSizeClassCached(sizeClass: ImageSizeClass) {
    guard let img = store.cache.getImage(forId: "test", ofSize: sizeClass) else { return }
    XCTAssertLessThanOrEqual(img.minSize, sizeClass.maxSmallerResolution)
  }
  
  func testSizeClass(sizeClass: ImageSizeClass) -> XCTestExpectation {
    let expectation = XCTestExpectation(description: "Test image getter for \(sizeClass.rawValue)")
    store.image(forId: "test", sizeClass: sizeClass) { image in
      if let image = image {
        XCTAssertLessThanOrEqual(image.minSize, sizeClass.maxSmallerResolution)
      }
      expectation.fulfill()
    }
    return expectation
  }
}
