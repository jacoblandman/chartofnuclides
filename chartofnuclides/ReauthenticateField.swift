//
//  ReauthenticateField.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/1/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class ReauthenticateField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderColor = UIColor(hexString: "C9C9C9").cgColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
    }
    
    func setPlaceholder(text: String) {
        let attributes = [
            NSForegroundColorAttributeName: UIColor(hexString: "C9C9C9"),
            NSFontAttributeName : UIFont(name: "Avenir-Medium", size: 14)! // Note the !
        ]
        
        self.attributedPlaceholder = NSAttributedString(string: text, attributes:attributes)
    }
}
