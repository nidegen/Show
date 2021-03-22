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

public extension Encodable {
  var jsonData: Data? { try? JSONEncoder().encode(self) }
  
  var dict: [String: Any] {
    guard let data = self.jsonData else { return [:] }
    guard let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)  else { return [:] }
    return dict as? [String: Any] ?? [:]
  }
}

public extension ExifData {
  var width: Int? { PixelXDimension }
  var height: Int? { PixelYDimension }
}

extension Dictionary where Key == String, Value: Any {
  func object<T: Decodable>() -> T? {
    if let data = try? JSONSerialization.data(withJSONObject: self, options: []) {
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
  
  func imageWith(exif: ExifData? = nil, gps: GPSData? = nil) -> CIImage {
    var props = properties
    exif.map { props["{Exif}"] = $0.dict }
    exif.map { props["{GPS}"] = $0.dict }
    return settingProperties(props)
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

public func flashTranlation(value: Int) -> Bool {
  (value & 1) != 0
//  | No Flash                                              | 0x0  | 00000000 | No    |
//  | Fired                                                 | 0x1  | 00000001 | Yes   |
//  | "Fired, Return not detected"                          | 0x5  | 00000101 | Yes   |
//  | "Fired, Return detected"                              | 0x7  | 00000111 | Yes   |
//  | "On, Did not fire"                                    | 0x8  | 00001000 | No    |
//  | "On, Fired"                                           | 0x9  | 00001001 | Yes   |
//  | "On, Return not detected"                             | 0xd  | 00001011 | Yes   |
//  | "On, Return detected"                                 | 0xf  | 00001111 | Yes   |
//  | "Off, Did not fire"                                   | 0x10 | 00010000 | No    |
//  | "Off, Did not fire, Return not detected"              | 0x14 | 00010100 | No    |
//  | "Auto, Did not fire"                                  | 0x18 | 00011000 | No    |
//  | "Auto, Fired"                                         | 0x19 | 00011001 | Yes   |
//  | "Auto, Fired, Return not detected"                    | 0x1d | 00011101 | Yes   |
//  | "Auto, Fired, Return detected"                        | 0x1f | 00011111 | Yes   |
//  |  No flash function                                    | 0x20 | 00100000 | No    |
//  | "Off, No flash function"                              | 0x30 | 00110000 | No    |
//  | "Fired, Red-eye reduction"                            | 0x41 | 01000001 | Yes   |
//  | "Fired, Red-eye reduction, Return not detected"       | 0x45 | 01000101 | Yes   |
//  | "Fired, Red-eye reduction, Return detected"           | 0x47 | 01000111 | Yes   |
//  | "On, Red-eye reduction"                               | 0x49 | 01001001 | Yes   |
//  | "On, Red-eye reduction, Return not detected"          | 0x4d | 01001101 | Yes   |
//  | "On, Red-eye reduction, Return detected"              | 0x4f | 01001111 | Yes   |
//  | "Off, Red-eye reduction"                              | 0x50 | 01010000 | No    |
//  | "Auto, Did not fire, Red-eye reduction"               | 0x58 | 01011000 | No    |
//  | "Auto, Fired, Red-eye reduction"                      | 0x59 | 01011001 | Yes   |
//  | "Auto, Fired, Red-eye reduction, Return not detected" | 0x5d | 01011101 | Yes   |
//  | "Auto, Fired, Red-eye reduction, Return detected"     | 0x5f | 01011111 | Yes
}

//public extension CGImage {
// public extension CGImage {
//  var a: Bool {let exifDict: NSDictionary = metaDict.object(forKey: kCGImagePropertyExifDictionary) as! NSDictionary}
// }
