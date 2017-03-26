//
//  StringSubStringExtension.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/15/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

extension String {

    func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.characters.count else {
                return ""
            }
        }
        
        if let end = to {
            guard end >= 0 else {
                return ""
            }
        }
        
        if let start = from, let end = to {
            guard end - start >= 0 else {
                return ""
            }
        }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.characters.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }
        
        return self[startIndex ..< endIndex]
    }
    
    func substring(from: Int) -> String {
        return self.substring(from: from, to: nil)
    }
    
    func substring(to: Int) -> String {
        return self.substring(from: nil, to: to)
    }
    
    func substring(from: Int?, length: Int) -> String {
        guard length > 0 else {
            return ""
        }
        
        let end: Int
        if let start = from, start > 0 {
            end = start + length - 1
        } else {
            end = length - 1
        }
        
        return self.substring(from: from, to: end)
    }
    
    func substring(length: Int, to: Int?) -> String {
        guard let end = to, end > 0, length > 0 else {
            return ""
        }
        
        let start: Int
        if let end = to, end - length > 0 {
            start = end - length + 1
        } else {
            start = 0
        }
        
        return self.substring(from: start, to: to)
    }

    mutating func stripUncertainty() {
        if let uncertainty = self.range(of: "+/-") {
            self.removeSubrange(uncertainty.lowerBound..<self.endIndex)
        }
        
        if let uncertainty = self.range(of: " (") {
            self.removeSubrange(uncertainty.lowerBound..<self.endIndex)
        }
    }
    
    func firstCharacter() -> Character {
        return self[self.startIndex]
    }
    
    struct Formatter {
        static let instance = NumberFormatter()
    }
    var doubleValue:Double? {
        return Formatter.instance.number(from: self)?.doubleValue
    }
    var integerValue:Int? {
        return Formatter.instance.number(from: self)?.intValue
    }
    
    func toBool() -> Bool {
        switch self.lowercased() {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return false
        }
    }
    
    func timeConverted() -> String? {
        
        if let doubleValue = self.doubleValue {
            if doubleValue > 1E7 {
                // convert to years
                if let convertedSolution = UnitConversionTypeManager.instance.converter.value(doubleValue, convertedFromUnit: "seconds", toUnit: "years") {
                    if convertedSolution.doubleValue > 1E5 {
                        return "\(convertedSolution.scientificStyle) a"
                    }
                    return "\(convertedSolution.doubleValue.roundedTo(places: 5)) a"
                }
            } else if doubleValue > 1E5 {
                // convert to days
                if let convertedSolution = UnitConversionTypeManager.instance.converter.value(doubleValue, convertedFromUnit: "seconds", toUnit: "days") {
                    return "\(convertedSolution.doubleValue.roundedTo(places: 5)) d"
                }
            } else if doubleValue > 1E4 {
                // convert to hours
                if let convertedSolution = UnitConversionTypeManager.instance.converter.value(doubleValue, convertedFromUnit: "seconds", toUnit: "hours") {
                    return "\(convertedSolution.doubleValue.roundedTo(places: 5)) h"
                }
            } else if doubleValue > 1E3 {
                // convert to minutes
                if let convertedSolution = UnitConversionTypeManager.instance.converter.value(doubleValue, convertedFromUnit: "seconds", toUnit: "minutes") {
                    return "\(convertedSolution.doubleValue.roundedTo(places: 5)) min"
                }
            } else if doubleValue < 1E-5 {
                return "\(doubleValue.scientificStyle) s"
            }
        }
        
        return nil
    }
    
    func squared() -> NSMutableAttributedString {
        
        let font = UIFont(name: "Avenir-medium", size: 16)
        let fontSuper = UIFont(name: "Avenir-light", size: 8)
        let attStr = NSMutableAttributedString(string: self.appending("2"), attributes: [NSFontAttributeName:font!])
        attStr.setAttributes([NSFontAttributeName:fontSuper!, NSBaselineOffsetAttributeName: 10], range: NSRange(location: self.characters.count, length: 1))
        return attStr
    }
    
    func cubed() -> NSMutableAttributedString {
        
        let font = UIFont(name: "Avenir-medium", size: 16)
        let fontSuper = UIFont(name: "Avenir-light", size: 8)
        let attStr = NSMutableAttributedString(string: self.appending("3"), attributes: [NSFontAttributeName:font!])
        attStr.setAttributes([NSFontAttributeName:fontSuper!, NSBaselineOffsetAttributeName: 10], range: NSRange(location: self.characters.count, length: 1))
        return attStr
    }
    
    func subscriptString(with substring: String, regularSize: CGFloat) -> NSMutableAttributedString {
        
        let font = UIFont(name: "Avenir-light", size: regularSize)
        let fontSub = UIFont(name: "Avenir-light", size: (regularSize - 2))
        let attStr = NSMutableAttributedString(string: self.appending(substring), attributes: [NSFontAttributeName:font!])
        attStr.setAttributes([NSFontAttributeName:fontSub!, NSBaselineOffsetAttributeName: -2], range: NSRange(location: self.characters.count, length: substring.characters.count))
        return attStr
        
        
    }
}
