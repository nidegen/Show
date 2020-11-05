import XCTest
@testable import Tools

final class ExifTests: XCTestCase {
  func testExif() {
    let imageURL = URL(string: "https://github.com/ianare/exif-samples/blob/master/jpg/gps/DSCN0038.jpg?raw=true")!
    let imageData = try! Data(contentsOf: imageURL)
    
    let ciimage = CIImage(data: imageData)!
    
    let data = ciimage.exif
    guard let gps = ciimage.gps else { XCTFail(); return }

    XCTAssertEqual(gps.latitude!, 43.467255, accuracy: 0.000001)
    XCTAssertEqual(gps.longitude!, 11.879213, accuracy: 0.000001)
    XCTAssertEqual(gps.timeStamp, DateFormatter.exifDateFormatter.date(from: "2008:10:23 14:50:40"))
    XCTAssert(data?.PixelXDimension == 640)
  }
  
  func testGPS() {
    let url = URL(string: "https://www.sylvaindurand.org/img/samples/thorsmork.jpg")!
    let imageData = try! Data(contentsOf: url)
    
    let ciimage = CIImage(data: imageData)!
    
    guard let gps = ciimage.gps else { XCTFail(); return }
    print(gps.Latitude)
    print(gps.Longitude)
    print(gps.LatitudeRef)
    print(gps.LongitudeRef)
    print(gps.DestBearing)
    print(gps.DestBearingRef)
    print("000")
  }
  
  func testUIImage() {
    let imageURL = URL(string: "https://github.com/ianare/exif-samples/blob/master/jpg/gps/DSCN0038.jpg?raw=true")!
    let imageData = try! Data(contentsOf: imageURL)
    let image = UIImage(data: imageData)!
    
    let ciimage = CIImage(data: imageData)!//image.jpegData(compressionQuality: 1)!)!
    
    let data = ciimage.exif
    guard let gps = ciimage.gps else { XCTFail(); return }

    XCTAssertEqual(gps.Latitude!, 43.467255, accuracy: 0.000001)
    XCTAssertEqual(gps.Longitude!, 11.879213, accuracy: 0.000001)
    XCTAssertEqual(gps.Longitude!, 11.879213, accuracy: 0.000001)
    XCTAssertEqual(gps.timeStamp, DateFormatter.exifDateFormatter.date(from: "2008:10:23 14:50:40"))
    XCTAssert(data?.PixelXDimension == 640)
  }
}
