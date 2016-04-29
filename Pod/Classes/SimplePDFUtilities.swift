//
//  SimplePDFUtilities.swift
//
//  Created by Muhammad Ishaq on 22/03/2015
//

import Foundation
import ImageIO
import UIKit

class SimplePDFUtilities {
    
    class func getApplicationInfoDictionary() -> Dictionary<NSObject, AnyObject> {
        let infoDictionary = NSMutableDictionary()
        infoDictionary.addEntriesFromDictionary(NSBundle.mainBundle().infoDictionary!)
        if let localizedInfoDictionary = NSBundle.mainBundle().localizedInfoDictionary {
            infoDictionary.addEntriesFromDictionary(localizedInfoDictionary)
        }
        return infoDictionary as Dictionary<NSObject, AnyObject>
    }
    
    class func getApplicationVersion() -> String {
        let dictionary = getApplicationInfoDictionary()
        
        guard let shortVersionString = dictionary["CFBundleShortVersionString"] as? String else {
            return ""
        }
        
        guard let build = dictionary["CFBundleVersion"] as? String else {
            return "\(shortVersionString)"
        }
        
        return "\(shortVersionString) Build: \(build)"
    }
    
    class func getApplicationName() -> String {
        let dictionary = getApplicationInfoDictionary()
        
        let name = dictionary["CFBundleName"] as! NSString
        
        return name as String
    }
    
    class func pathForTmpFile(fileName: String) -> String {
        let tmpDirPath = NSTemporaryDirectory() as NSString
        let path = tmpDirPath.stringByAppendingPathComponent(fileName)
        return path
    }
    
    class func renameFilePathToPreventNameCollissions(path: NSString) -> String {
        let fileManager = NSFileManager()
        
        // append a postfix if file name is already taken
        var postfix = 0
        var newPath = path
        while(fileManager.fileExistsAtPath(newPath as String)) {
            postfix += 1
            
            let pathExtension = path.pathExtension
            newPath = path.stringByDeletingPathExtension
            newPath = newPath.stringByAppendingString(" \(postfix)")
            newPath = newPath.stringByAppendingPathExtension(pathExtension)!
        }
        
        return newPath as String
    }
    
    class func getImageProperties(imagePath: String) -> NSDictionary {
        let imageURL = NSURL(fileURLWithPath: imagePath)
        guard let imageSourceRef = CGImageSourceCreateWithURL(imageURL, nil) else {
            return NSDictionary()
        }

        let propertiesAsCFDictionary = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, nil)
        // translating it to an optional NSDictionary (instead of as? operator) because:
        // http://stackoverflow.com/questions/32716146/cfdictionary-wont-bridge-to-nsdictionary-swift-2-0-ios9
        guard let propertiesAsNSDictionary = propertiesAsCFDictionary as NSDictionary? else {
            return NSDictionary()
        }
        
        return propertiesAsNSDictionary
    }
    
    class func getNumericListAlphabeticTitleFromInteger(value: Int) -> String {
        let base:Int = 26
        let unicodeLetterA :UnicodeScalar = "\u{0061}" // a
        var mutableValue = value
        var result = ""
        repeat {
            let remainder = mutableValue % base
            mutableValue = mutableValue - remainder
            mutableValue = mutableValue / base
            let unicodeChar = UnicodeScalar(remainder + Int(unicodeLetterA.value))
            result = String(unicodeChar) + result
        
        } while mutableValue > 0
        
        return result
    }
    
    class func generateThumbnail(imageURL: NSURL, size: CGSize, callback: (thumbnail: UIImage, fromURL: NSURL, size: CGSize) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            if let imageSource = CGImageSourceCreateWithURL(imageURL, nil) {
                let options = [
                    kCGImageSourceThumbnailMaxPixelSize as String: max(size.width, size.height),
                    kCGImageSourceCreateThumbnailFromImageIfAbsent as String: true
                ]
                
                if let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options) {
                    let thumbnail = UIImage(CGImage: cgImage)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        callback(thumbnail: thumbnail, fromURL: imageURL, size: size)
                    })
                }
            }
        })
    }
}
