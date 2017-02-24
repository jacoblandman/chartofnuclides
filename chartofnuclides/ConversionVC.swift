//
//  ConversionVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/23/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class ConversionVC: UIViewController {

    enum SelectingUnit {
        case input
        case output
        case none
    }
    
    @IBOutlet weak var inputUnitBg: GradientView!
    @IBOutlet weak var outputUnitBg: GradientView!
    @IBOutlet weak var inputValueBg: GradientView!
    @IBOutlet weak var outputValueBg: GradientView!
    @IBOutlet weak var inputTextField: InputTextField!
    @IBOutlet weak var outputTextField: InputTextField!
    @IBOutlet weak var deleteKeyImg: UIImageView!
    @IBOutlet weak var inputUnitLbl: UILabel!
    @IBOutlet weak var outputUnitLbl: UILabel!
    @IBOutlet weak var inputUnitSymbol: UILabel!
    @IBOutlet weak var outputUnitSymbol: UILabel!
    @IBOutlet weak var whiteBg: UIView!
    @IBOutlet weak var greyBg: UIView!
    @IBOutlet var btns: [ConversionButton]!
    
    var viewsShownAfterAnimation = [UIView]()
    var orderedViewsToBeAnimated = [AnyObject]()
    
    var selectingUnit: SelectingUnit = .none
    
    var unitTypes = [String]()
    
    var triangleLayer: CAShapeLayer?
    var tableMask: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setGradients()
        inputTextField.setPlaceholder(with: "Enter Value")
        outputTextField.setPlaceholder(with: "0.0", color: colorWithHexString(hex: "98D8F7"))
        setTextFieldKeyboards()
        setAnimationViews()
    }
    
    func setOutputValue() {

        if let input = inputTextField.text, input.characters.count > 0 {
            if let value = input.doubleValue {
                if let convertedSolution = UnitConversionTypeManager.instance.converter.value(value, convertedFromUnit: inputUnitLbl.text!.lowercased(), toUnit: outputUnitLbl.text!.lowercased()) {
                    outputTextField.text = "\( convertedSolution.formatToFitIn(outputTextField))"
                } else {
                    outputTextField.text = "Invalid Conversion"
                }
            } else {
                outputTextField.text = "NAN"
            }
        } else {
            outputTextField.text = "0.0"
        }
    }

    @IBAction func digitClick(_ sender: ConversionButton) {
        
        // we know the button has a title label and text
        // if it doesn't then that is a problem
        inputTextField.text?.append(sender.titleLabel!.text!)
        setOutputValue()
        
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        // if we havent entered a value yet then remove the placeholder text
        inputTextField.becomeFirstResponder()
        if inputTextField.text != "" && inputTextField.text != nil {
            if let selectedRange = inputTextField.selectedTextRange {
                let cursorPosition = inputTextField.offset(from: inputTextField.beginningOfDocument, to: selectedRange.start)
                
                // nothing to delete if the cursor is at the front
                guard cursorPosition > 0 else { return }
                
                inputTextField.text?.remove(at: inputTextField.text!.index(inputTextField.text!.startIndex, offsetBy: cursorPosition - 1))
                if let newCursorPosition = inputTextField.position(from: selectedRange.start, offset: -1) {
                    inputTextField.selectedTextRange = inputTextField.textRange(from: newCursorPosition, to: newCursorPosition)
                }
                
                setOutputValue()
            }
        }
    }
    
    @IBAction func deleteHeld(_ sender: Any) {
        inputTextField.text = ""
        outputTextField.text = "0.0"
    }
    
    func setGradients() {
        inputUnitBg.setValuesForRadialGradient(color1: colorWithHexString(hex: "FFD276"), color2: UIColor.white, relativeCenterPoint: CGPoint(x: 0.5, y: 0.5), innerRadius: inputUnitBg.frame.width / 6, outerRadius: inputUnitBg.frame.width * 1.5)
        inputValueBg.setValuesForLinearGradient(color1: UIColor.white, color2: colorWithHexString(hex: "FFEFCD"), relativeStartPoint: CGPoint(x: 0.5, y: 0), relativeEndPoint: CGPoint(x: 0.5, y: 0.5))
        outputUnitBg.setValuesForRadialGradient(color1: colorWithHexString(hex: "98D8F7"), color2: UIColor.white, relativeCenterPoint: CGPoint(x: 0.5, y: 0.5), innerRadius: outputUnitBg.frame.width / 6, outerRadius: outputUnitBg.frame.width * 1.5)
        outputValueBg.setValuesForLinearGradient(color1: UIColor.white, color2: colorWithHexString(hex: "CAECFD"), relativeStartPoint: CGPoint(x: 0.5, y: 0), relativeEndPoint: CGPoint(x: 0.5, y: 0.5))
    }
    
    func setTextFieldKeyboards() {
        // here we are setting the text field input views to dummy views to prevent the ios keyboard from popping up
        // we are using our own keys
        let dummyView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        inputTextField.inputView = dummyView
        outputTextField.inputView = dummyView
    }
    
    func setAnimationViews() {
        viewsShownAfterAnimation = [whiteBg, greyBg]
        orderedViewsToBeAnimated = [inputUnitBg, inputValueBg, outputUnitBg, outputValueBg]
        for btn in btns {
            orderedViewsToBeAnimated.append(btn)
        }
    }
}

