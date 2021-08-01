import XCTest
import MobileCoreServices
import ImageIO

@testable import Tools

final class ExifTests: XCTestCase {
  let fileManager = FileManager()
  
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
//    let image = UIImage(data: imageData)!
    
    let ciimage = CIImage(data: imageData)!//image.jpegData(compressionQuality: 1)!)!
    
    let data = ciimage.exif
    guard let gps = ciimage.gps else { XCTFail(); return }

    XCTAssertEqual(gps.Latitude!, 43.467255, accuracy: 0.000001)
    XCTAssertEqual(gps.Longitude!, 11.879213, accuracy: 0.000001)
    XCTAssertEqual(gps.Longitude!, 11.879213, accuracy: 0.000001)
    XCTAssertEqual(gps.timeStamp, DateFormatter.exifDateFormatter.date(from: "2008:10:23 14:50:40"))
    XCTAssert(data?.PixelXDimension == 640)
  }
  
  func testExifSetter() {
    let url = URL(string: "https://user-images.githubusercontent.com/8779423/111466775-f9d4a580-8723-11eb-8846-7522e41765cd.jpg")!
    guard let imageData = try? Data(contentsOf: url) else {
      XCTFail()
      return
    }
    
    let originalImageURL = fileManager.temporaryDirectory.appendingPathComponent("exifTestOriginal.jpg")
    let editedImageURL = fileManager.temporaryDirectory.appendingPathComponent("exifTestEdited.jpg")
    
    try? imageData.write(to: originalImageURL, options: .atomic)
    
    let exifData: ExifData = .exampleData
    let gpsData: GPSData = .exampleData
    
    try? copyImageWithExifData(exif: exifData, gps: gpsData, sourceURL: originalImageURL, destinationURL: editedImageURL)
    
    let editedImageData = try! Data(contentsOf: editedImageURL)
//    let props = CIImage(data: editedImageData)!.exifPropertyDictionary
//    let propSoll = exifData.encodedDictionary
    
    
    
    guard let editedExif =  CIImage(data: editedImageData)!.exif else { XCTFail(); return }
    guard let editedGPS =  CIImage(data: editedImageData)!.gps else { XCTFail(); return }
    
    XCTAssert(exifData.LensMake == editedExif.LensMake)
    XCTAssert(exifData.ApertureValue == editedExif.ApertureValue)
    XCTAssert(exifData.UserComment == editedExif.UserComment)
    XCTAssert(exifData.Contrast == editedExif.Contrast)
    XCTAssert(exifData.FocalLength == editedExif.FocalLength)
    print(exifData.DateTimeOriginal)
    print(editedExif.DateTimeOriginal)
    XCTAssert(exifData.DateTimeOriginal == editedExif.DateTimeOriginal)
    
    XCTAssert(gpsData.Latitude == editedGPS.Latitude)
    XCTAssert(gpsData.Longitude == editedGPS.Longitude)
    XCTAssert(gpsData.Altitude == editedGPS.Altitude)
    XCTAssert(gpsData.TimeStamp == editedGPS.TimeStamp)
    XCTAssert(gpsData.DateStamp == editedGPS.DateStamp)
    XCTAssert(gpsData.timeStamp == Date(timeIntervalSince1970: 1606083741))
  }
  
  func testWrite() {
    let url = URL(string: "https://user-images.githubusercontent.com/8779423/111466775-f9d4a580-8723-11eb-8846-7522e41765cd.jpg")!
    guard let imageData = try? Data(contentsOf: url) else {
      XCTFail()
      return
    }
    
    let sourceURL = fileManager.temporaryDirectory.appendingPathComponent("exifTestOriginal.jpg")
    let destinationURL = fileManager.temporaryDirectory.appendingPathComponent("exifTestEdited.jpg")
    try? imageData.write(to: sourceURL, options: .atomic)

    
    guard let outputImage = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypeJPEG, 1, nil) else {
      fatalError()
    }
    
    guard let imageSource = CGImageSourceCreateWithURL(sourceURL as CFURL, nil) else {
      fatalError()
    }
    
    var properties: [NSString: AnyObject] = [:]
    let newTime = "2020:11:22 22:11:00"
     properties[kCGImagePropertyExifDictionary] = [kCGImagePropertyExifDateTimeOriginal: newTime] as CFDictionary
    
    CGImageDestinationAddImageFromSource(outputImage, imageSource, 0, properties as CFDictionary)
    CGImageDestinationFinalize(outputImage)
    
    let editedImageData = try! Data(contentsOf: destinationURL)
    let editedCIImage =  CIImage(data: editedImageData)!
    let props = editedCIImage.properties["{Exif}"] as? [String: Any]
    let editedDateTime = props![kCGImagePropertyExifDateTimeOriginal as String] as! String
    XCTAssert(editedDateTime == newTime)
  }
}

