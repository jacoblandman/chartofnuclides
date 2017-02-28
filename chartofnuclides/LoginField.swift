//
//  LoginField.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/27/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class LoginField: UITextField {

    override func awakeFromNib() {
        let placeholderText = self.placeholder!
        setPlaceholder(text: placeholderText)
        
        // set border
        self.layer.borderColor = UIColor(hexString: "979797").cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 25
    }
    
    func setPlaceholder(text: String) {
        let attributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName : UIFont(name: "Avenir-Medium", size: 14)! // Note the !
        ]
        
        self.attributedPlaceholder = NSAttributedString(string: text, attributes:attributes)
    }


}
