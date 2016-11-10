//
//  SimplePDFUtilities.swift
//
//  Created by Muhammad Ishaq on 22/03/2015
//

import Foundation
import ImageIO
import UIKit

class SimplePDFUtilities {
    
    class func getApplicationInfoDictionary() -> NSDictionary {
        let infoDictionary = NSMutableDictionary()
        infoDictionary.addEntries(from: Bundle.main.infoDictionary!)
        if let localizedInfoDictionary = Bundle.main.localizedInfoDictionary {
            infoDictionary.addEntries(from: localizedInfoDictionary)
        }
        return infoDictionary
    }
    
    class func getApplicationVersion() -> String {
        let dictionary = getApplicationInfoDictionary()
        
        let shortVersionString = dictionary["CFBundleShortVersionString"] as? String ?? ""
        let build = dictionary["CFBundleVersion"] as? String ?? ""
        return "\(shortVersionString) Build: \(build)"
    }
    
    class func getApplicationName() -> String {
        let dictionary = getApplicationInfoDictionary()
        
        let name = dictionary["CFBundleName"] as! NSString
        
        return name as String
    }
    
    class func pathForTmpFile(_ fileName: String) -> String {
        let tmpDirPath = NSTemporaryDirectory() as NSString
        let path = tmpDirPath.appendingPathComponent(fileName)
        return path
    }
    
    class func renameFilePathToPreventNameCollissions(_ path: NSString) -> String {
        let fileManager = FileManager()
        
        // append a postfix if file name is already taken
        var postfix = 0
        var newPath = path
        while(fileManager.fileExists(atPath: newPath as String)) {
            postfix += 1
            
            let pathExtension = path.pathExtension
            newPath = path.deletingPathExtension as NSString
            newPath = newPath.appending(" \(postfix)") as NSString
            newPath = newPath.appendingPathExtension(pathExtension)! as NSString
        }
        
        return newPath as String
    }
    
    class func getImageProperties(_ imagePath: String) -> NSDictionary {
        let imageURL = URL(fileURLWithPath: imagePath)
        guard let imageSourceRef = CGImageSourceCreateWithURL(imageURL as CFURL, nil) else {
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
    
    class func getNumericListAlphabeticTitleFromInteger(_ value: Int) -> String {
        let base:Int = 26
        let unicodeLetterA :UnicodeScalar = "\u{0061}" // a
        var mutableValue = value
        var result = ""
        repeat {
            let remainder = mutableValue % base
            mutableValue = mutableValue - remainder
            mutableValue = mutableValue / base
            let unicodeChar = UnicodeScalar(remainder + Int(unicodeLetterA.value))
            result = String(describing: unicodeChar) + result
        
        } while mutableValue > 0
        
        return result
    }
    
    class func generateThumbnail(_ imageURL: URL, size: CGSize, callback: @escaping (_ thumbnail: UIImage, _ fromURL: URL, _ size: CGSize) -> Void) {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: { () -> Void in
            if let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, nil) {
                let options = [
                    kCGImageSourceThumbnailMaxPixelSize as String: max(size.width, size.height),
                    kCGImageSourceCreateThumbnailFromImageIfAbsent as String: true
                ] as [String : Any]
                
                if let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary?) {
                    let thumbnail = UIImage(cgImage: cgImage)
                    DispatchQueue.main.async(execute: { () -> Void in
                        callback(thumbnail, imageURL, size)
                    })
                }
            }
        })
    }
}
