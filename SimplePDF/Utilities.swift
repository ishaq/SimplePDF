//
//  SimplePDFUtilities.swift
//
//  Created by Muhammad Ishaq on 22/03/2015
//

import Foundation
import ImageIO
import UIKit

class SimplePDFUtilities {
    class func getApplicationVersion() -> String {
        var dictionary: Dictionary<NSObject, AnyObject>!
        if (NSBundle.mainBundle().localizedInfoDictionary != nil) {
            dictionary = NSBundle.mainBundle().localizedInfoDictionary! as Dictionary
        }
        else {
            dictionary = NSBundle.mainBundle().infoDictionary!
        }
        let build = dictionary["CFBundleVersion"] as NSString
        let shortVersionString = dictionary["CFBundleShortVersionString"] as NSString
        
        return "(\(shortVersionString) Build: \(build))"
    }
    
    class func getApplicationName() -> String {
        var dictionary: Dictionary<NSObject, AnyObject>!
        if (NSBundle.mainBundle().localizedInfoDictionary != nil) {
            dictionary = NSBundle.mainBundle().localizedInfoDictionary! as Dictionary
        }
        else {
            dictionary = NSBundle.mainBundle().infoDictionary!
        }
        let name = dictionary["CFBundleName"] as NSString
        
        return name
    }
    
    class func pathForTmpFile(fileName: String) -> String {
        let fileManager = NSFileManager()
        let tmpDirPath = NSTemporaryDirectory()
        let path = tmpDirPath.stringByAppendingPathComponent(fileName)
        return path
    }
    
    class func renameFilePathToPreventNameCollissions(var path: String) -> String {
        let fileManager = NSFileManager()
        
        // append a postfix if file name is already taken
        var postfix = 0
        while(fileManager.fileExistsAtPath(path)) {
            postfix++
            
            let pathExtension = path.pathExtension
            path = path.stringByDeletingPathExtension
            path = path.stringByAppendingString(" \(postfix)")
            path = path.stringByAppendingPathExtension(pathExtension)!
        }
        
        return path
        
    }
    
    class func getImageProperties(imagePath: String) -> NSDictionary {
        let imageURL = NSURL(fileURLWithPath: imagePath)
        let imageSourceRef = CGImageSourceCreateWithURL(imageURL, nil)
        let props = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, nil)
        return props as NSDictionary
    }
    
    class func getNumericListAlphabeticTitleFromInteger(value: Int) -> String {
        let base:Int = 26
        let unicodeLetterA :UnicodeScalar = "\u{0061}" // a
        var mutableValue = value
        var result = ""
        do {
            let remainder = mutableValue % base
            mutableValue = mutableValue - remainder
            mutableValue = mutableValue / base
            let unicodeChar = UnicodeScalar(remainder + unicodeLetterA.value)
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
                
                let scaledImage = UIImage(CGImage: CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options))
                if let thumbnail = scaledImage {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        callback(thumbnail: thumbnail, fromURL: imageURL, size: size)
                    })
                }
            }
        })
    }
}