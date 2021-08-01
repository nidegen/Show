//
//  UIImage+Exif.swift
//  Echo
//
//  Created by Nicolas Degen on 21.04.19.
//  Copyright © 2019 Echo Labs AG. All rights reserved.
//

import CoreMedia
import CoreMotion
import CoreLocation
import MobileCoreServices
import ImageIO
import UIKit

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:  [UIImagePickerController.InfoKey : Any]) {
  
}

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
    var exifData: CFDictionary? = nil
    if let data = self.jpegData(compressionQuality: 1.0) {
      data.withUnsafeBytes {
        let bytes = $0.baseAddress?.assumingMemoryBound(to: UInt8.self)
        if let cfData = CFDataCreate(kCFAllocatorDefault, bytes, data.count),
           let source = CGImageSourceCreateWithData(cfData, nil) {
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
    GPSMetadata[(kCGImagePropertyGPSLatitude as String)] = abs(self.coordinate.latitude)
    GPSMetadata[(kCGImagePropertyGPSLongitude as String)] = abs(self.coordinate.longitude)
    GPSMetadata[(kCGImagePropertyGPSLatitudeRef as String)] = latitudeRef
    GPSMetadata[(kCGImagePropertyGPSLongitudeRef as String)] = longitudeRef
    GPSMetadata[(kCGImagePropertyGPSAltitude as String)] = Int(abs(self.altitude))
    GPSMetadata[(kCGImagePropertyGPSAltitudeRef as String)] = altitudeRef
    GPSMetadata[(kCGImagePropertyGPSTimeStamp as String)] = self.timestamp.isoTime()
    GPSMetadata[(kCGImagePropertyGPSDateStamp as String)] = self.timestamp.isoDate()
    GPSMetadata[(kCGImagePropertyGPSVersion as String)] = "2.2.0.0"
    
    if let heading = heading {
      GPSMetadata[(kCGImagePropertyGPSImgDirection as String)] = heading.trueHeading
      GPSMetadata[(kCGImagePropertyGPSImgDirectionRef as String)] = "T"
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

extension Data {
  func addExif(exif: ExifData, gps: GPSData) {
    let jpeg = self
    var source: CGImageSource? = nil
    source = CGImageSourceCreateWithData((jpeg as CFData?)!, nil)
    let metadata = CGImageSourceCopyPropertiesAtIndex(source!, 0, nil) as? [AnyHashable: Any]
    let metadataAsMutable = metadata
    var EXIFDictionary = (metadataAsMutable?[(kCGImagePropertyExifDictionary as String)]) as? [AnyHashable: Any]
    var GPSDictionary = (metadataAsMutable?[(kCGImagePropertyGPSDictionary as String)]) as? [AnyHashable: Any]
    
    if !(EXIFDictionary != nil) {
      EXIFDictionary = [AnyHashable: Any]()
    }
    if !(GPSDictionary != nil) {
      GPSDictionary = [AnyHashable: Any]()
    }
    
    GPSDictionary![(kCGImagePropertyGPSLatitude as String)] = 30.21313
    GPSDictionary![(kCGImagePropertyGPSLongitude as String)] = 76.22346
    EXIFDictionary![(kCGImagePropertyExifUserComment as String)] = "Hello Image"
    
    let UTI: CFString = CGImageSourceGetType(source!)!
    let dest_data = NSMutableData()
    let destination: CGImageDestination = CGImageDestinationCreateWithData(dest_data as CFMutableData, UTI, 1, nil)!
    CGImageDestinationAddImageFromSource(destination, source!, 0, (metadataAsMutable as CFDictionary?))
    CGImageDestinationFinalize(destination)
  }
  
  func setEXIFUserComment(_ comment: String, using sourceURL: URL, destination destinationURL: URL) {
    
    guard let imageDestination = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypeJPEG, 1, nil)
    else { fatalError("Image destination not created") }
    
    guard let metadataTag = CGImageMetadataTagCreate(kCGImageMetadataNamespaceExif, kCGImageMetadataPrefixExif, kCGImagePropertyExifUserComment, .string, comment as CFString)
    else { fatalError("Metadata tag not created") }
    
    let metadata = CGImageMetadataCreateMutable()
    
    let exifUserCommentPath = "\(kCGImageMetadataPrefixExif):\(kCGImagePropertyExifUserComment)" as CFString
    CGImageMetadataSetTagWithPath(metadata, nil, exifUserCommentPath, metadataTag)
    
    guard let imageSource = CGImageSourceCreateWithURL(sourceURL as CFURL, nil)
    else { fatalError("Image source not created") }
    
    guard let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
    else { fatalError("Image not created from source") }
    
    CGImageDestinationAddImageAndMetadata(imageDestination, image, metadata, nil)
    CGImageDestinationFinalize(imageDestination)
  }
  
//  func createTempDirectory() -> String? {
//      let tempDirectoryTemplate = NSTemporaryDirectory().stringByAppendingPathComponent("XXXXX")
//
//      let fileManager = NSFileManager.defaultManager()
//
//      var err: NSErrorPointer = nil
//      if fileManager.createDirectoryAtPath(tempDirectoryTemplate, withIntermediateDirectories: true, attributes: nil, error: err) {
//          return tempDirectoryTemplate
//      } else {
//          return nil
//      }
//    let stringToSave = "The string I want to save"
//    let path = FileManager.default.urls(for: .documentDirectory,
//                                        in: .userDomainMask)[0].appendingPathComponent("myFile")
//
//    if let stringData = stringToSave.data(using: .utf8) {
//        try? stringData.write(to: path)
//    }
//  }
  
  
  func setEXIFUserComment2(_ exifData: ExifData, sourceURL: URL, destinationURL: URL) {
    guard let outputImage = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypeJPEG, 1, nil)
    else { fatalError("Image destination not created") }
    
    guard let imageSource = CGImageSourceCreateWithURL(sourceURL as CFURL, nil)
    else { fatalError("Image source not created") }
    
    guard let exifDictionary: [String: Any] = exifData.encodedDictionary else { return }
    let exifNSDictionary = exifDictionary as [NSString: AnyObject]
    let properties: [NSString: AnyObject] = [ kCGImagePropertyExifDictionary: exifNSDictionary as CFDictionary ]
    
    CGImageDestinationAddImageFromSource(outputImage, imageSource, 0, properties as CFDictionary)
    CGImageDestinationFinalize(outputImage)
  }
}

public enum ShowError: Error {
    case exifError(String)
}

public func copyImageWithExifData(exif: ExifData? = nil, gps: GPSData? = nil, sourceURL: URL, destinationURL: URL) throws {
  guard let outputImage = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypeJPEG, 1, nil) else {
    throw ShowError.exifError("Image destination not created")
  }
  
  guard let imageSource = CGImageSourceCreateWithURL(sourceURL as CFURL, nil) else {
    throw ShowError.exifError("Image source not created")
  }
  
  var properties: [NSString: AnyObject] = [:]
  
  if let exifData = exif {
    guard let exifDictionary: [String: Any] = exifData.encodedDictionary else {
      throw ShowError.exifError("Dict not encoded")
    }
    let exifNSDictionary = exifDictionary as [NSString: AnyObject]
    properties[kCGImagePropertyExifDictionary] = exifNSDictionary as CFDictionary
  }
  
  if let gpsData = gps {
    guard let gpsDictionary: [String: Any] = gpsData.encodedDictionary else {
      throw ShowError.exifError("Dict not encoded")
    }
    let gpsNSDictionary = gpsDictionary as [NSString: AnyObject]
    properties[kCGImagePropertyGPSDictionary] = gpsNSDictionary as CFDictionary
  }
  
  CGImageDestinationAddImageFromSource(outputImage, imageSource, 0, properties as CFDictionary)
  CGImageDestinationFinalize(outputImage)
}
