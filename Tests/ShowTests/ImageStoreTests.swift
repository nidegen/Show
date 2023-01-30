import XCTest
@testable import Show

final class ImageStoreTests: XCTestCase {
  var store = ImageStore(server: MockServer())
  
  override func setUp() {
    guard let imageURL = URL(string: "https://source.unsplash.com/random"),
          let randomImage = try? UIImage(data: Data(contentsOf: imageURL)) else { XCTFail(); return }
    store.uploadNewImage(randomImage, id: "testImage")
  }
  
  func testStore() async {
    var expectations: [XCTestExpectation] = []
    for format in ImageFormat.allCases {
      expectations += [await testImageFormat(format: format)]
    }
    await fulfillment(of: expectations, timeout: 2.0)
    for format in ImageFormat.allCases {
      testFormatCached(format: format)
    }
  }
  
  func testFormatCached(format: ImageFormat) {
    guard let img = store.cache.getImage(forId: "test", format: format) else { return }
    XCTAssertLessThanOrEqual(img.minSize, format.maxSmallerResolution)
  }
  
  func testImageFormat(format: ImageFormat) async -> XCTestExpectation {
    let expectation = XCTestExpectation(description: "Test image getter for \(format.rawValue)")
    if let image = try? await store.image(forId: "test", format: format) {
      XCTAssertLessThanOrEqual(image.minSize, format.maxSmallerResolution)
    } else {
      XCTFail("no image")
    }
    expectation.fulfill()
    return expectation
  }
}
