//
//  UIImageExtension.swift
//  JTL
//
//  Created by Jacob Landman on 12/5/16.
//  Copyright © 2016 Jacob Landman. All rights reserved.
//

import Foundation

import UIKit

extension UIImage {
    
    func resizeWith(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func resizeWith(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    // this resizing is using Core Graphics. It is possible that Image I/O is a better option
    func resize(maxHeight: CGFloat, maxWidth: CGFloat) -> UIImage? {
        var actualHeight = self.size.height
        var actualWidth = self.size.width
        let maxHeight = maxHeight
        let maxWidth = maxWidth
        var imgRatio = actualWidth/actualHeight
        let maxRatio = maxWidth/maxHeight
        //let compressionQuality = 0.5//50 percent compression
        let cgImage = self.cgImage!
        
        if (actualHeight > maxHeight || actualWidth > maxWidth)
        {
            if(imgRatio < maxRatio)
            {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            } else if(imgRatio > maxRatio) {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            } else {
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        let bitsPerComponent = cgImage.bitsPerComponent
        let bytesPerRow = cgImage.bytesPerRow
        let colorSpace = cgImage.colorSpace
        let bitmapInfo = cgImage.bitmapInfo
        
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        let context = CGContext(data: nil, width: Int(actualWidth), height: Int(actualHeight), bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace!, bitmapInfo: bitmapInfo.rawValue)
        context?.interpolationQuality = .high
        context?.draw(cgImage, in: rect)
        let scaledImage = UIImage(cgImage: (context?.makeImage())!)

        return scaledImage
        
    }
}
