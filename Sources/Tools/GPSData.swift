import Foundation
import CoreLocation

public struct GPSData: Codable {
  public var VersionID: [Int]?
  public var LatitudeRef: String?
  public var Latitude: Double?
  public var LongitudeRef: String?
  public var Longitude: Double?
  public var AltitudeRef: Int?
  public var Altitude: Double?
  public var TimeStamp: String?
  public var Satellites: String?
  public var Status: [String]?
  public var MeasureMode: [String]?
  public var DOP: Double?
  public var SpeedRef: String?
  public var Speed: Double?
  public var TrackRef: String?
  public var Track: Double?
  public var ImgDirectionRef: String?
  public var ImgDirection: Double?
  public var MapDatum: String?
  public var DestLatitudeRef: String?
  public var DestLatitude: Double?
  public var DestLongitudeRef: String?
  public var DestLongitude: Double?
  public var DestBearingRef: String?
  public var DestBearing: Double?
  public var DestDistanceRef: String?
  public var DestDistance: Double?
  public var ProcessingMethod: String?
  public var AreaInformation: String?
  public var DateStamp: String?
  public var Differential: Int? //0 = No Correction; 1 = Differential Corrected
  public var HPositioningError: Double?
  
  public init(){}
}

public extension GPSData {
  var timeStamp: Date? {
    guard let time = TimeStamp else { return nil }
    guard let date = DateStamp else { return nil }
    return DateFormatter.exifDateFormatter.date(from: date + " " + time)
  }
  
  var latitude: Double? {
    guard let lat = Latitude else { return nil }
    let ref = LatitudeRef == "S" ? -1.0 : 1.0
    return lat * ref
  }
  
  var longitude: Double? {
    guard let lon = Longitude else { return nil }
    let ref = LongitudeRef == "W" ? -1.0 : 1.0
    return lon * ref
  }
  
  var destinationLatitude: Double? {
    guard let lat = DestLatitude else { return nil }
    let ref = DestLatitudeRef == "S" ? -1.0 : 1.0
    return lat * ref
  }
  
  var destinationLongitude: Double? {
    guard let lon = DestLongitude else { return nil }
    let ref = DestLongitudeRef == "W" ? -1.0 : 1.0
    return lon * ref
  }
  
  var destinationMagneticBearing: Double? {
    if DestBearingRef != "M" { return nil }
    return DestBearing
  }
  
  var azimuthMagnetic: Double? {
    if ImgDirectionRef != "M" { return nil }
    return ImgDirection
  }
  
  // Distance in meters
  var destinationDistance: Double? {
    guard let dist = DestDistance else { return nil }
    if DestDistanceRef == "N" {
      return dist * 1852
    }
    if DestDistanceRef == "M" {
      return dist * 1609.34
    }
    return dist * 1000 // Assuming DestDistanceRef == "K" aka km
  }
  
  var altitude: Double? {
    guard let alt = Altitude else { return nil }
    // if reference is 1, the altitude is below sea level
    let ref = AltitudeRef == 1 ? -1.0 : 1.0
    return alt * ref
  }
  
  var location: CLLocation? {
    guard let long = longitude, let lat = latitude,
          let alt = altitude, let date = timeStamp
          else { return nil }
    
    let coords = CLLocationCoordinate2D(latitude: lat, longitude: long)
    return CLLocation(coordinate: coords, altitude: alt, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: date)
  }
}
