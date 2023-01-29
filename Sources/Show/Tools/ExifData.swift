import Foundation

public struct ExifData: Codable {
  public var PixelXDimension: Int?
  public var PixelYDimension: Int?
  public var SubjectArea: [Int]?
  public var LensMake: String?
  public var LensModel: String?
  public var UniqueCameraModel: String?
  public var Orientation: Int?
  public var CustomRendered: Int?
  public var LensSpecification: [Double]?
  public var FocalLenIn35mmFilm: Int?
  public var ColorSpace: Int?
  public var WhiteBalance: Int?
  public var BrightnessValue: Double?
  public var ApertureValue: Double?
  public var ShutterSpeedValue: Double?
  public var ISOSpeedRatings: [Int]?
  public var SensingMethod: Int?
  public var FocalLength: Double?
  public var FocalPlaneXResolution: Double?
  public var FocalPlaneYResolution: Double?
  public var FocalPlaneResolutionUnit: Int?
  public var FNumber: Double?
  public var ExposureProgram: Int?
  public var ExposureMode: Int?
  public var ExposureBiasValue: Double?
  public var ExposureTime: Double?
  public var MeteringMode: Int?
  public var Flash: Int?
  public var FlashPixVersion: [Int]?
  public var DateTimeOriginal: Date?
  public var DateTimeDigitized: Date?
  public var SubsecTime: String?
  public var SubsecTimeOriginal: String?
  public var SubsecTimeDigitized: String?
  public var SceneType: Int?
  public var SceneCaptureType: Int?
  public var ComponentsConfiguration: [Int]?
  public var ExifVersion: [Int]?
  
  public var DigitalZoomRatio: Double?
  public var FileSource: Int?
  public var Contrast: Int?
  public var GainControl: Int?
  public var LightSource: Int?
  public var CompressedBitsPerPixel: Int?
  public var UserComment: String?
  public var Sharpness: Int?
  public var Saturation: Int?
  public var MaxApertureValue: Double?
  public var ImageUniqueID: String?
  
  public init() {}
}

public extension ExifData {
  var width: Int? { PixelXDimension }
  var height: Int? { PixelYDimension }
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
