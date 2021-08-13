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
    for size in ImageSizeClass.allCases {
      testSizeClass(sizeClass: size)
    }
    for size in ImageSizeClass.allCases {
      testSizeClassCached(sizeClass: size)
    }
  }
  
  func testSizeClassCached(sizeClass: ImageSizeClass) {
    guard let img = store.cache.getImage(forId: "test", ofSize: sizeClass) else { XCTFail(); return }
    print(img.maxSize)
    XCTAssert(img.maxSize <= sizeClass.maxSize);
  }
  
  func testSizeClass(sizeClass: ImageSizeClass) {
    let expectation = XCTestExpectation(description: "Test image getter for \(sizeClass.rawValue)")
    store.image(forId: "test", sizeClass: sizeClass) { image in
      guard let image = image else { XCTFail(); return }
      print(image.maxSize)
      XCTAssert(image.maxSize <= sizeClass.maxSize);
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 3.0)
  }
}
