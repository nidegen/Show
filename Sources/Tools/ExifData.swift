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
  
  public var DigitalZoomRatio: Int?
  public var FileSource: Int?
  public var Contrast: Int?
  public var GainControl: Int?
  public var LightSource: Int?
  public var CompressedBitsPerPixel: Int?
  public var UserComment: String?
  public var Sharpness: Int?
  public var Saturation: Int?
  public var MaxApertureValue: Int?
  public var ImageUniqueID: String?
  
  public init() {}
}

public extension ExifData {
  var width: Int? { PixelXDimension }
  var height: Int? { PixelYDimension }
}
