//
//  UIImage+Exif.swift
//  Echo
//
//  Created by Nicolas Degen on 21.04.19.
//  Copyright © 2019 Echo Labs AG. All rights reserved.
//

#if canImport(UIKit)
import CoreLocation
import CoreMedia
import CoreMotion
import ImageIO
import MobileCoreServices
import UIKit

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {}

extension UIImage {
  func getExifDataB() -> NSDictionary? {
    if let imageData = self.jpegData(compressionQuality: 1.0) {
      let imageCFData = imageData as CFData
      if let cgImage = CGImageSourceCreateWithData(imageCFData, nil), let metaDict: NSDictionary = CGImageSourceCopyPropertiesAtIndex(cgImage, 0, nil) {
        let exifDict: NSDictionary = metaDict.object(forKey: kCGImagePropertyExifDictionary) as! NSDictionary
        return exifDict
      }
    }
    return nil
  }

  func getExifDataA() -> CFDictionary? {
    var exifData: CFDictionary?
    if let data = self.jpegData(compressionQuality: 1.0) {
      data.withUnsafeBytes {
        let bytes = $0.baseAddress?.assumingMemoryBound(to: UInt8.self)
        if let cfData = CFDataCreate(kCFAllocatorDefault, bytes, data.count),
           let source = CGImageSourceCreateWithData(cfData, nil)
        {
          exifData = CGImageSourceCopyPropertiesAtIndex(source, 0, nil)
        }
      }
    }
    return exifData
  }

  func write(toUrl: URL, withJPEGQuality quality: CGFloat, withMetadata metadata: NSMutableDictionary, location: CLLocation) {
    let imageData = self.jpegData(compressionQuality: quality)
    metadata[kCGImagePropertyGPSDictionary as String] = location.exifMetadata()

    let annotatedImageData: NSMutableData = writeMetadata(intoImageData: imageData, metadata: metadata)

    try! annotatedImageData.write(to: URL(fileURLWithPath: "asdf"))
    return
  }
}

extension UIImage.Orientation {
  var cgImagePropertyOrientation: Int {
    var newOrientation: Int
    switch self {
    case .up:
      newOrientation = 1
    case .down:
      newOrientation = 3
    case .left:
      newOrientation = 8
    case .right:
      newOrientation = 6
    case .upMirrored:
      newOrientation = 2
    case .downMirrored:
      newOrientation = 4
    case .leftMirrored:
      newOrientation = 5
    case .rightMirrored:
      newOrientation = 7
    default:
      newOrientation = -1
    }
    return newOrientation
  }

  //  usage:
//  metaData[kCGImagePropertyOrientation as String] = orientation.cgImagePropertyOrientation
}

func writeMetadata(intoImageData imageData: Data?, metadata: NSMutableDictionary) -> NSMutableData {
  let metadata = metadata
  // create an imagesourceref
  let source = CGImageSourceCreateWithData(imageData! as CFData, nil)

  // this is the type of image (e.g., public.jpeg)
//  let UTI = CGImageSourceGetType(source!)

  // create a new data object and write the new image into it
  let newData = NSMutableData()
  let destination = CGImageDestinationCreateWithData(newData as CFMutableData, kUTTypePNG, 1, nil)
  #if false
    if !destination {
      print("Error: Could not create image destination")
    }
  #endif
  // add the image contained in the image source to the destination, overidding the old metadata with our modified metadata
  CGImageDestinationAddImageFromSource(destination!, source!, 0, metadata as CFDictionary)
  var success = false
  success = CGImageDestinationFinalize(destination!)
  if !success {
    print("Error: Could not create data from image destination")
  }
  return newData
}

extension CLLocation {
  func exifMetadata(heading: CLHeading? = nil) -> NSMutableDictionary {
    let GPSMetadata = NSMutableDictionary()
    let altitudeRef = Int(self.altitude < 0.0 ? 1 : 0)
    let latitudeRef = self.coordinate.latitude < 0.0 ? "S" : "N"
    let longitudeRef = self.coordinate.longitude < 0.0 ? "W" : "E"

    // GPS metadata
    GPSMetadata[kCGImagePropertyGPSLatitude as String] = abs(self.coordinate.latitude)
    GPSMetadata[kCGImagePropertyGPSLongitude as String] = abs(self.coordinate.longitude)
    GPSMetadata[kCGImagePropertyGPSLatitudeRef as String] = latitudeRef
    GPSMetadata[kCGImagePropertyGPSLongitudeRef as String] = longitudeRef
    GPSMetadata[kCGImagePropertyGPSAltitude as String] = Int(abs(self.altitude))
    GPSMetadata[kCGImagePropertyGPSAltitudeRef as String] = altitudeRef
    GPSMetadata[kCGImagePropertyGPSTimeStamp as String] = self.timestamp.isoTime()
    GPSMetadata[kCGImagePropertyGPSDateStamp as String] = self.timestamp.isoDate()
    GPSMetadata[kCGImagePropertyGPSVersion as String] = "2.2.0.0"

    if let heading = heading {
      GPSMetadata[kCGImagePropertyGPSImgDirection as String] = heading.trueHeading
      GPSMetadata[kCGImagePropertyGPSImgDirectionRef as String] = "T"
    }

    return GPSMetadata
  }
}

extension Date {
  func isoDate() -> String {
    let f = DateFormatter()
    f.timeZone = TimeZone(abbreviation: "UTC")
    f.dateFormat = "yyyy:MM:dd"
    return f.string(from: self)
  }

  func isoTime() -> String {
    let f = DateFormatter()
    f.timeZone = TimeZone(abbreviation: "UTC")
    f.dateFormat = "HH:mm:ss.SSSSSS"
    return f.string(from: self)
  }
}

#endif
