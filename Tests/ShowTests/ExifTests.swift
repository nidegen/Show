import XCTest
@testable import Show

final class ExifTests: XCTestCase {
  func testExif() {
    let imageURL = URL(string: "https://user-images.githubusercontent.com/8779423/111466775-f9d4a580-8723-11eb-8846-7522e41765cd.jpg")!
    let imageData = try! Data(contentsOf: imageURL)

    let ciimage = CIImage(data: imageData)!

    guard let exif = ciimage.exif else { XCTFail(); return }

    XCTAssertEqual(exif.DateTimeDigitized, DateFormatter.exifDateFormatter.date(from: "2021:02:08 13:30:44"))
    XCTAssertEqual(exif.LensModel, "iPhone 7 back camera 3.99mm f/1.8")
    XCTAssertEqual(exif.LensMake, "Apple")
  }
  
  func testGPS() {
    let url = URL(string: "https://user-images.githubusercontent.com/8779423/111466775-f9d4a580-8723-11eb-8846-7522e41765cd.jpg")!
    guard let imageData = try? Data(contentsOf: url) else {
      XCTFail()
      return
    }

    let ciimage = CIImage(data: imageData)!

    guard let gps = ciimage.gps else { XCTFail(); return }
    XCTAssertEqual(gps.Longitude, 8.7678883333333335)
    XCTAssertEqual(gps.Latitude, 47.009972216666668)
    XCTAssertEqual(gps.LatitudeRef, "N")
    XCTAssertEqual(gps.LongitudeRef, "E")
    XCTAssertEqual(gps.DestBearing, 220.4888)
    XCTAssertEqual(gps.DestBearingRef, "T")
    XCTAssertEqual(gps.Altitude, 1700.0185840707964)
  }

  func testUIImage() {
    let imageURL = URL(string: "https://github.com/ianare/exif-samples/blob/master/jpg/gps/DSCN0038.jpg?raw=true")!
    let imageData = try! Data(contentsOf: imageURL)
    let image = UIImage(data: imageData)!

    let ciimage = CIImage(data: imageData)! // image.jpegData(compressionQuality: 1)!)!

    let data = ciimage.exif
    guard let gps = ciimage.gps else { XCTFail(); return }

    XCTAssertEqual(gps.Latitude!, 43.467255, accuracy: 0.000001)
    XCTAssertEqual(gps.Longitude!, 11.879213, accuracy: 0.000001)
    XCTAssertEqual(gps.Longitude!, 11.879213, accuracy: 0.000001)
    XCTAssertEqual(gps.timeStamp, DateFormatter.exifDateFormatter.date(from: "2008:10:23 14:50:40"))
    XCTAssert(data?.PixelXDimension == 640)
  }
}
