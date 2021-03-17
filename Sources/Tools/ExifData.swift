import CoreImage
import Foundation

public struct ExifData: Codable {
  let PixelXDimension: Int?
  let PixelYDimension: Int?
  public let SubjectArea: [Int]?
  public let LensMake: String?
  public let LensModel: String?
  public let UniqueCameraModel: String?
  public let Orientation: Int?
  public let CustomRendered: Int?
  public let LensSpecification: [Double]?
  public let FocalLenIn35mmFilm: Int?
  public let ColorSpace: Int?
  public let WhiteBalance: Int?
  public let BrightnessValue: Double?
  public let ApertureValue: Double?
  public let ShutterSpeedValue: Double?
  public let ISOSpeedRatings: [Int]?
  public let SensingMethod: Int?
  public let FocalLength: Double?
  public let FocalPlaneXResolution: Double?
  public let FocalPlaneYResolution: Double?
  public let FocalPlaneResolutionUnit: Int?
  public let FNumber: Double?
  public let ExposureProgram: Int?
  public let ExposureMode: Int?
  public let ExposureBiasValue: Double?
  public let ExposureTime: Double?
  public let MeteringMode: Int?
  public let Flash: Int?
  public let FlashPixVersion: [Int]?
  public let DateTimeOriginal: Date?
  public let DateTimeDigitized: Date?
  public let SubsecTime: String?
  public let SubsecTimeOriginal: String?
  public let SubsecTimeDigitized: String?
  public let SceneType: Int?
  public let SceneCaptureType: Int?
  public let ComponentsConfiguration: [Int]?
  public let ExifVersion: [Int]?
  
  public let DigitalZoomRatio: Int?
  public let FileSource: Int?
  public let Contrast: Int?
  public let GainControl: Int?
  public let LightSource: Int?
  public let CompressedBitsPerPixel: Int?
  public let UserComment: String?
  public let Sharpness: Int?
  public let Saturation: Int?
  public let MaxApertureValue: Int?
  public let ImageUniqueID: String?
}

public extension ExifData {
  var width: Int? { PixelXDimension }
  var height: Int? { PixelYDimension }
}

extension Dictionary where Key == String, Value: Any {
  func object<T: Decodable>() -> T? {
    if let data = try? JSONSerialization.data(withJSONObject: self, options: []) {
//      if let jsonString = String(data: data, encoding: .utf8) {
//        print(jsonString)
//      }
      do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.exifDateFormatter)
        let value = try decoder.decode(T.self, from: data)
        return value
      } catch {
        print(error)
      }
      return nil
    } else {
      return nil
    }
  }
}

public extension DateFormatter {
  static let exifDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
    return formatter
  }()
}

public extension CIImage {
  var exifPropertyDictionary: [String: Any]? {
    properties["{Exif}"] as? [String: Any]
  }

  var exif: ExifData? {
    exifPropertyDictionary?.object()
  }

  var gpsPropertyDictionary: [String: Any]? {
    properties["{GPS}"] as? [String: Any]
  }

  var gps: GPSData? {
    gpsPropertyDictionary?.object()
  }
}

// public extension CGImage {
//  var a: Bool {let exifDict: NSDictionary = metaDict.object(forKey: kCGImagePropertyExifDictionary) as! NSDictionary}
// }
