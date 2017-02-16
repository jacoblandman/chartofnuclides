//
//  ConverterCalcCell.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/15/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class ConverterCalcCell: UICollectionViewCell {
    
    @IBOutlet weak var mainLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    func update(with indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 || indexPath.row == 1 {
                bgView.backgroundColor = colorWithHexString(hex: "FFD276")
            } else {
                bgView.backgroundColor = colorWithHexString(hex: "98D8F7")
            }
            mainLbl.text = "Hello"
            
        } else {
            mainLbl.text = "\(indexPath.row)"
        }
    }
}
