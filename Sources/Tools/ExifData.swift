import CoreImage
import Foundation
import AVFoundation.AVCapturePhotoOutput

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
  func decoded<T: Decodable>() -> T? {
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
    exifPropertyDictionary?.decoded()
  }

  var gpsPropertyDictionary: [String: Any]? {
    properties["{GPS}"] as? [String: Any]
  }

  var gps: GPSData? {
    gpsPropertyDictionary?.decoded()
  }
}

public extension AVCapturePhoto {
  var exifMetadata: ExifData? {
    ExifData(PixelXDimension: metadata[kCGImagePropertyWidth as String] as? Int,
             PixelYDimension: metadata[kCGImagePropertyHeight as String] as? Int,
             SubjectArea: metadata[kCGImagePropertyExifSubjectArea as String] as? [Int],
             LensMake: metadata[kCGImagePropertyExifLensMake as String] as? String,
             LensModel: metadata[kCGImagePropertyExifLensModel as String] as? String,
             UniqueCameraModel: metadata[kCGImagePropertyDNGUniqueCameraModel as String] as? String,
             Orientation: metadata[kCGImagePropertyOrientation as String] as? Int,
             CustomRendered: metadata[kCGImagePropertyExifCustomRendered as String] as? Int,
             LensSpecification: metadata[kCGImagePropertyExifLensSpecification as String] as? [Double],
             FocalLenIn35mmFilm: metadata[kCGImagePropertyExifFocalLenIn35mmFilm as String] as? Int,
             ColorSpace: metadata[kCGImagePropertyExifColorSpace as String] as? Int,
             WhiteBalance: metadata[kCGImagePropertyExifWhiteBalance as String] as? Int,
             BrightnessValue: metadata[kCGImagePropertyExifBrightnessValue as String] as? Double,
             ApertureValue: metadata[kCGImagePropertyExifApertureValue as String] as? Double,
             ShutterSpeedValue: metadata[kCGImagePropertyExifShutterSpeedValue as String] as? Double,
             ISOSpeedRatings: metadata[kCGImagePropertyExifISOSpeedRatings as String] as? [Int],
             SensingMethod: metadata[kCGImagePropertyExifSensingMethod as String] as? Int,
             FocalLength: metadata[kCGImagePropertyExifFocalLength as String] as? Double,
             FocalPlaneXResolution: metadata[kCGImagePropertyExifFocalPlaneXResolution as String] as? Double,
             FocalPlaneYResolution: metadata[kCGImagePropertyExifFocalPlaneYResolution as String] as? Double,
             FocalPlaneResolutionUnit: metadata[kCGImagePropertyExifFocalPlaneResolutionUnit as String] as? Int,
             FNumber: metadata[kCGImagePropertyExifFNumber as String] as? Double,
             ExposureProgram: metadata[kCGImagePropertyExifExposureProgram as String] as? Int,
             ExposureMode: metadata[kCGImagePropertyExifExposureMode as String] as? Int,
             ExposureBiasValue: metadata[kCGImagePropertyExifExposureBiasValue as String] as? Double,
             ExposureTime: metadata[kCGImagePropertyExifExposureTime as String] as? Double,
             MeteringMode: metadata[kCGImagePropertyExifMeteringMode as String] as? Int,
             Flash: metadata[kCGImagePropertyExifFlash as String] as? Int,
             FlashPixVersion: metadata[kCGImagePropertyExifFlashPixVersion as String] as? [Int],
             DateTimeOriginal: metadata[kCGImagePropertyExifDateTimeOriginal as String] as? Date,
             DateTimeDigitized: metadata[kCGImagePropertyExifDateTimeDigitized as String] as? Date,
             SubsecTime: metadata[kCGImagePropertyExifSubsecTime as String] as? String,
             SubsecTimeOriginal: metadata[kCGImagePropertyExifSubsecTimeOriginal as String] as? String,
             SubsecTimeDigitized: metadata[kCGImagePropertyExifSubsecTimeDigitized as String] as? String,
             SceneType: metadata[kCGImagePropertyExifSceneType as String] as? Int,
             SceneCaptureType: metadata[kCGImagePropertyExifSceneCaptureType as String] as? Int,
             ComponentsConfiguration: metadata[kCGImagePropertyExifComponentsConfiguration as String] as? [Int],
             ExifVersion: metadata[kCGImagePropertyExifVersion as String] as? [Int],
             DigitalZoomRatio: metadata[kCGImagePropertyExifDigitalZoomRatio as String] as? Int,
             FileSource: metadata[kCGImagePropertyExifFileSource as String] as? Int,
             Contrast: metadata[kCGImagePropertyExifContrast as String] as? Int,
             GainControl: metadata[kCGImagePropertyExifGainControl as String] as? Int,
             LightSource: metadata[kCGImagePropertyExifLightSource as String] as? Int,
             CompressedBitsPerPixel: metadata[kCGImagePropertyExifCompressedBitsPerPixel as String] as? Int,
             UserComment: metadata[kCGImagePropertyExifUserComment as String] as? String,
             Sharpness: metadata[kCGImagePropertyExifSharpness as String] as? Int,
             Saturation: metadata[kCGImagePropertyExifSaturation as String] as? Int,
             MaxApertureValue: metadata[kCGImagePropertyExifMaxApertureValue as String] as? Int,
             ImageUniqueID: metadata[kCGImagePropertyExifImageUniqueID as String] as? String)
  }
  
  
  var gpsMetadata: GPSData? {
    GPSData(
      VersionID: metadata[kCGImagePropertyGPSVersion as String] as? [Int], 
      LatitudeRef: metadata[kCGImagePropertyGPSLatitudeRef as String] as? String,
      Latitude: metadata[kCGImagePropertyGPSLatitude as String] as? Double,
      LongitudeRef: metadata[kCGImagePropertyGPSLongitudeRef as String] as? String,
      Longitude: metadata[kCGImagePropertyGPSLongitude as String] as? Double,
      AltitudeRef: metadata[kCGImagePropertyGPSAltitudeRef as String] as? Int,
      Altitude: metadata[kCGImagePropertyGPSAltitude as String] as? Double,
      TimeStamp: metadata[kCGImagePropertyGPSTimeStamp as String] as? String,
      Satellites: metadata[kCGImagePropertyGPSSatellites as String] as? String,
      Status: metadata[kCGImagePropertyGPSStatus as String] as? [String],
      MeasureMode: metadata[kCGImagePropertyGPSMeasureMode as String] as? [String],
      DOP: metadata[kCGImagePropertyGPSDOP as String] as? Double,
      SpeedRef: metadata[kCGImagePropertyGPSSpeedRef as String] as? String,
      Speed: metadata[kCGImagePropertyGPSSpeed as String] as? Double,
      TrackRef: metadata[kCGImagePropertyGPSTrackRef as String] as? String,
      Track: metadata[kCGImagePropertyGPSTrack as String] as? Double,
      ImgDirectionRef: metadata[kCGImagePropertyGPSImgDirectionRef as String] as? String,
      ImgDirection: metadata[kCGImagePropertyGPSImgDirection as String] as? Double,
      MapDatum: metadata[kCGImagePropertyGPSMapDatum as String] as? String,
      DestLatitudeRef: metadata[kCGImagePropertyGPSDestLatitudeRef as String] as? String,
      DestLatitude: metadata[kCGImagePropertyGPSDestLatitude as String] as? Double,
      DestLongitudeRef: metadata[kCGImagePropertyGPSDestLongitudeRef as String] as? String,
      DestLongitude: metadata[kCGImagePropertyGPSDestLongitude as String] as? Double,
      DestBearingRef: metadata[kCGImagePropertyGPSDestBearingRef as String] as? String,
      DestBearing: metadata[kCGImagePropertyGPSDestBearing as String] as? Double,
      DestDistanceRef: metadata[kCGImagePropertyGPSDestDistanceRef as String] as? String,
      DestDistance: metadata[kCGImagePropertyGPSDestDistance as String] as? Double,
      ProcessingMethod: metadata[kCGImagePropertyGPSProcessingMethod as String] as? String,
      AreaInformation: metadata[kCGImagePropertyGPSAreaInformation as String] as? String,
      DateStamp: metadata[kCGImagePropertyGPSDateStamp as String] as? String,
      Differential: metadata[kCGImagePropertyGPSDifferental as String] as? Int,
      HPositioningError: metadata[kCGImagePropertyGPSHPositioningError as String] as? Double)
  }
}
