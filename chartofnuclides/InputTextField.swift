//
//  InputTextField.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/22/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class InputTextField: UITextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    func requiredFontSize() -> CGFloat {
        let textBounds = self.textRect(forBounds: self.frame)
        let maxWidth = textBounds.size.width
        
        var font = self.font
        var fontSize = self.font!.pointSize
        
        repeat {
            
            font = font?.withSize(fontSize)
            
            let size = (self.text! as NSString).size(attributes: [NSFontAttributeName: font!])
            print(size)
            if (size.width <= maxWidth) {
                break
            }
            
            fontSize = fontSize - 1.0
            if fontSize < self.minimumFontSize {
                fontSize = self.minimumFontSize
                break
            }
        } while (true)
        
        return fontSize
        
    }
    
    func resizeFont() {
        let startFontSize = 31
        let minFontSize = 8
        
        guard let font = self.font, let text = self.text else {
            return
        }
        
        let textBounds = self.textRect(forBounds: self.bounds)
        let maxWidth = textBounds.size.width
        
        for fontSize in stride(from: startFontSize, through: minFontSize, by: -1) {
            let size = (text as NSString).size(attributes: [NSFontAttributeName: font.withSize(CGFloat(fontSize))])
            self.font = font.withSize(CGFloat(fontSize))
            if size.width <= maxWidth {
                break
            }
        }
    }
    
    func setPlaceholder(with text: String) {
        let attributes = [
            NSForegroundColorAttributeName: colorWithHexString(hex: "FDBE4D"),
            NSFontAttributeName : UIFont(name: "Avenir-Medium", size: 23)! // Note the !
        ]
        
        self.attributedPlaceholder = NSAttributedString(string: text, attributes:attributes)
    }
    
    func setPlaceholder(with text: String, color: UIColor) {
        let attributes = [
            NSForegroundColorAttributeName: color,
            NSFontAttributeName : UIFont(name: "Avenir-Medium", size: 23)! // Note the !
        ]
        
        self.attributedPlaceholder = NSAttributedString(string: text, attributes:attributes)
    }
}


