//
//  FileManager.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/16/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class CustomFileManager: NSObject {

    static func saveImageToDisk(image: UIImage) {
        
        CustomFileManager.removeCurrentImage()
        
        let fileManager = FileManager.default
        
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appending("/profile.jpg")
        let imgData = UIImageJPEGRepresentation(image, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imgData, attributes: nil)
    }
    
    static func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    static func getImage() -> UIImage? {
        let fileManager = FileManager.default
        let imagePath = (CustomFileManager.getDirectoryPath() as NSString).appendingPathComponent("profile.jpg")
        
        var image: UIImage
        if fileManager.fileExists(atPath: imagePath) {
            image = UIImage(contentsOfFile: imagePath)!
            return image
        } else {
            return nil
        }
    }
    
    static func removeCurrentImage() {
        let fileManager = FileManager.default
        let imagePath = (CustomFileManager.getDirectoryPath() as NSString).appendingPathComponent("profile.jpg")
        
        if fileManager.fileExists(atPath: imagePath) {
            do {
                try fileManager.removeItem(atPath: imagePath)
            } catch {
                print("JACOB: Error attempting to delete image from disk")
            }
        }
    }
}
