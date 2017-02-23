//
//  ConverterCalcCell.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/20/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class ConverterCalcCell: UICollectionViewCell {
    
    @IBOutlet weak var mainLbl: UILabel!
    @IBOutlet weak var bgView: GradientView!
    @IBOutlet weak var lblLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTrailingConstraint: NSLayoutConstraint!
    var deleteButton: UIButton?
    
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

            case 1:
                self.updateInputValueCell()
                
            case 2:
                self.updateOutputUnitCell()
                
            default:
                self.updateOutputValueCell()
                
            }
            
            
            
        } else {
            
            switch (indexPath.row) {
            case 0,1,2,3,4,5,6,7,8:
                self.updateNumberCell(row: indexPath.row)
            case 9:
                mainLbl.text = "."
            case 10:
                mainLbl.text = "0"
            default:
                mainLbl.text = "E"
                //self.addDeleteImage()
                
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
        
        lblLeadingConstraint.constant = max(self.frame.width / 15, 10)
        lblTrailingConstraint.constant = 54
        mainLbl.textAlignment = .left
        
        mainLbl.font = UIFont(name: "Avenir-Heavy", size: 32)
        mainLbl.textColor = colorWithHexString(hex: "FDBE4D")
        mainLbl.text = "Enter Value"
        mainLbl.adjustsFontSizeToFitWidth = true
        
        
        let textField = InputTextField(frame: self.frame)
        textField.font = UIFont(name: "Avenir-Heavy", size: 32)
        textField.textColor = colorWithHexString(hex: "FDBE4D")
        textField.text = "Enter Value"
        textField.adjustsFontSizeToFitWidth = true
        
        self.addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -lblTrailingConstraint.constant).isActive = true
        NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: textField, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        
        
        addDeleteButton(to: self)
        
    }
    
    func updateOutputUnitCell() {
        bgView.setValuesForRadialGradient(color1: colorWithHexString(hex: "98D8F7"), color2: UIColor.white, centerPoint: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), innerRadius: self.frame.width / 6, outerRadius: self.frame.width * 1.5)
        bgView.setNeedsDisplay()
        
        mainLbl.textColor = UIColor.white
        
    }
    
    func updateOutputValueCell() {
        bgView.setValuesForLinearGradient(color1: UIColor.white, color2: colorWithHexString(hex: "CAECFD"), startPoint: CGPoint(x: self.frame.width / 2, y: 0), endPoint: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2))
        bgView.setNeedsDisplay()
        
        lblLeadingConstraint.constant = max(self.frame.width / 15, 10)
        lblTrailingConstraint.constant = 50
        mainLbl.textAlignment = .left
        
        mainLbl.font = UIFont(name: "Avenir-Heavy", size: 32)
        mainLbl.textColor = colorWithHexString(hex: "55C6FE")
        mainLbl.text = "0.0"
        mainLbl.adjustsFontSizeToFitWidth = true
        
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
    
    func addDeleteButton(to cell: ConverterCalcCell) {
        
        let btnFrame = CGRect(x: cell.frame.minX + cell.frame.width - 44, y: cell.frame.midY - 22, width: 44, height: 44)
        
        let image = UIImage(named: "delete_color")
        let imageView = UIImageView(image: image!)
        imageView.contentMode = .center
        imageView.frame = btnFrame
        cell.addSubview(imageView)
        cell.bringSubview(toFront: imageView)
        
        deleteButton = UIButton()
        deleteButton!.frame = btnFrame
        let holdGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(buttonHeld))
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        deleteButton!.addGestureRecognizer(holdGesture)
        deleteButton!.addGestureRecognizer(tapGesture)

        cell.addSubview(deleteButton!)
        cell.bringSubview(toFront: deleteButton!)
        
        deleteButton!.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: deleteButton!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0).isActive = true
        NSLayoutConstraint(item: deleteButton!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0).isActive = true
        NSLayoutConstraint(item: deleteButton!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: deleteButton!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
    }
    
    func buttonHeld() {
        if let btn = deleteButton {
            btn.delegate.buttonHeld()
        }
    }
    
    func buttonTapped() {
        if let btn = deleteButton {
            btn.delegate.buttonTapped()
        }
    }
    
}
