//
//  NSNumberExtension.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/23/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

extension NSNumber {
    
    func formatToFitIn(_ textField: UITextField) -> String {
        if let font = textField.font {
            let size = (self.stringValue as NSString).size(attributes: [NSFontAttributeName: font.withSize(font.pointSize)])
            if size.width > textField.frame.width {
                return self.scientificStyle
            }
        }
        
        return self.stringValue
    }
    
    struct Formatter {
        static var instance = NumberFormatter()
    }
    
    var scientificStyle: String {
        Formatter.instance.numberStyle = .scientific
        Formatter.instance.positiveFormat = "0.####E+0"
        Formatter.instance.exponentSymbol = "E"
        return Formatter.instance.string(from: self) ?? description
    }
}
