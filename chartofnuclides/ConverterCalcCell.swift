//
//  ConverterCalcCellTest.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/20/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class ConverterCalcCellTest: UICollectionViewCell {
    
    @IBOutlet weak var mainLbl: UILabel!
    @IBOutlet weak var bgView: GradientView!
    @IBOutlet weak var lblLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTrailingConstraint: NSLayoutConstraint!
    
    func highlight() {
        self.alpha = 0.2
    }
    
    func unhighlight() {
        self.alpha = 1.0
    }
    
    func update(with indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            switch (indexPath.row) {
            case 0:
                self.updateInputUnitCell()
            //bgView.backgroundColor = colorWithHexString(hex: "FFD276")
            case 1:
                self.updateInputValueCell()
                
            case 2:
                self.updateOutputUnitCell()
                
            default:
                self.updateOutputValueCell()
                
            }
            
            mainLbl.text = "Hello"
            
        } else {
            
            switch (indexPath.row) {
            case 0,1,2,3,4,5,6,7,8:
                self.updateNumberCell(row: indexPath.row)
            case 9:
                mainLbl.text = "."
            case 10:
                mainLbl.text = "0"
            default:
                mainLbl.text = ""
                self.addDeleteImage()
                
            }
        }
    }
    
    func updateInputUnitCell() {
        bgView.setValuesForRadialGradient(color1: colorWithHexString(hex: "FFD276"), color2: UIColor.white, centerPoint: self.center, innerRadius: self.frame.width / 6, outerRadius: self.frame.width * 1.5)
        bgView.setNeedsDisplay()
        
        mainLbl.textColor = UIColor.white
    }
    
    func updateInputValueCell() {
        bgView.setValuesForLinearGradient(color1: UIColor.white, color2: colorWithHexString(hex: "FFEFCD"), startPoint: CGPoint(x: self.frame.width / 2, y: 0), endPoint: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2))
        bgView.setNeedsDisplay()
        
        lblLeadingConstraint.constant = self.frame.width / 6
        lblTrailingConstraint.constant = self.frame.width / 6
        mainLbl.textAlignment = .left
        
        mainLbl.font = UIFont(name: "Avenir-Heavy", size: 48)
        mainLbl.textColor = colorWithHexString(hex: "FDBE4D")
        
    }
    
    func updateOutputUnitCell() {
        bgView.setValuesForRadialGradient(color1: colorWithHexString(hex: "98D8F7"), color2: UIColor.white, centerPoint: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), innerRadius: self.frame.width / 6, outerRadius: self.frame.width * 1.5)
        bgView.setNeedsDisplay()
        
        mainLbl.textColor = UIColor.white
        
    }
    
    func updateOutputValueCell() {
        bgView.setValuesForLinearGradient(color1: UIColor.white, color2: colorWithHexString(hex: "CAECFD"), startPoint: CGPoint(x: self.frame.width / 2, y: 0), endPoint: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2))
        bgView.setNeedsDisplay()
        
        lblLeadingConstraint.constant = self.frame.width / 6
        lblTrailingConstraint.constant = self.frame.width / 6
        mainLbl.textAlignment = .left
        
        mainLbl.font = UIFont(name: "Avenir-Heavy", size: 48)
        mainLbl.textColor = colorWithHexString(hex: "55C6FE")
        
        self.isUserInteractionEnabled = false
        
    }
    
    func updateNumberCell(row: Int) {
        mainLbl.text = "\(row + 1)"
    }
    
    func addDeleteImage() {
        let image = UIImage(named: "delete")
        let imageView = UIImageView(image: image!)
        imageView.contentMode = .center
        imageView.frame = self.frame
        self.addSubview(imageView)
        self.bringSubview(toFront: imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
    }
    
}
