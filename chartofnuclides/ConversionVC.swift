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
    
    @IBOutlet weak var tableViewBg: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mask: UIView!
    @IBOutlet weak var XView: GradientView!
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
    var unitAbbreviations = [String: Any]()
    
    var triangleLayer: CAShapeLayer?
    var tableMask: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setGradients()
        inputUnitLbl.text = unitTypes[0]
        outputUnitLbl.text = unitTypes[1]
        setSymbols()
        inputTextField.setPlaceholder(with: "Enter Value")
        outputTextField.setPlaceholder(with: "0.0", color: colorWithHexString(hex: "98D8F7"))
        setTextFieldKeyboards()
        setAnimationViews()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setSymbols() {
        
        let inputAbb = unitAbbreviations[unitTypes[0]]
        if let inAbb = inputAbb as? NSMutableAttributedString {
            inputUnitSymbol.attributedText = inAbb
        } else {
            inputUnitSymbol.text = inputAbb as? String
        }
        
        let outputAbb = unitAbbreviations[unitTypes[1]]
        if let outAbb = outputAbb as? NSMutableAttributedString {
            outputUnitSymbol.attributedText = outAbb
        } else {
            outputUnitSymbol.text = outputAbb as? String
        }
        
    }
    
    func animateXView() {
        // a nice animation for the done button
        if XView.alpha != 1.0 {
            XView.leo_animateCircleExpand(from: mask, duration: 0.35, delay: 0.0, alpha: 1.0, options: LeoMaskAnimationOptions.easeIn, compeletion: nil)
            
            tableViewBg.leo_animateCircleExpand(from: tableMask!, duration: 0.5, delay: 0.0, alpha: 1.0, options:LeoMaskAnimationOptions.easeIn, compeletion: nil)
            UIView.animate(withDuration: 0.0) {
                self.XView.alpha = 1.0
                self.tableViewBg.alpha = 1.0
            }
        }
    }
    
    func createTriangle(size: CGFloat, x: CGFloat, y: CGFloat) {
        // create an arrow that points to the left
        
        if let triangle = triangleLayer {
            triangle.position = CGPoint(x: x ,y: y)
        } else {
            triangleLayer = CAShapeLayer()
            let trianglePath = UIBezierPath()
            trianglePath.move(to: .zero)
            trianglePath.addLine(to: CGPoint(x: size, y: size))
            trianglePath.addLine(to: CGPoint(x: size, y: -size))
            trianglePath.close()
            
            triangleLayer!.path = trianglePath.cgPath
            triangleLayer!.fillColor = UIColor.white.cgColor
            triangleLayer!.anchorPoint = .zero
            triangleLayer!.position = CGPoint(x: x ,y: y)
            triangleLayer!.name = "triangle"
            view.layer.addSublayer(triangleLayer!)
        }
    }
    
    @IBAction func outputLblTapped(_ sender: Any) {
        let size: CGFloat = 10
        // convert the triangle x and y to the super view coordinate system
        var triPoint = CGPoint(x: outputUnitBg.frame.maxX, y: outputUnitBg.frame.midY)
        triPoint = view.convert(triPoint, from: outputUnitBg)
        createTriangle(size: size, x: triPoint.x - size + 1, y: triPoint.y)
        tableMask = UIView(frame: CGRect(x: -10, y: triangleLayer!.frame.minY, width: 10, height: 10))
        
        selectingUnit = .output
        animateXView()

    }
    
    @IBAction func inputLblTapped(_ sender: Any) {
        let size: CGFloat = 10
        // convert the triangle x and y to the super view coordinate system
        var triPoint = CGPoint(x: inputUnitBg.frame.maxX, y: inputUnitBg.frame.midY)
        triPoint = view.convert(triPoint, from: inputUnitBg)
        createTriangle(size: size, x: triPoint.x - size + 1, y: triPoint.y)
        tableMask = UIView(frame: CGRect(x: -10, y: triangleLayer!.frame.minY, width: 10, height: 10))
        
        selectingUnit = .input
        animateXView()
    }
    
    @IBAction func XBtnPressed(_ sender: Any) {
        
        removeTableView()
    }
    
    func removeTableView() {
        selectingUnit = .none
        
        let animationDuration = 0.5
        
        XView.leo_removeMaskAnimations()
        XView.leo_animateReverseCircleExpand(to: mask, duration: animationDuration, delay: 0.0, alpha: 0.0, options: LeoMaskAnimationOptions.easeOut, completion: nil)
        tableViewBg.leo_animateReverseCircleExpand(to: tableMask!, duration: animationDuration, delay: 0.0, alpha: 0.0, options: LeoMaskAnimationOptions.easeOut, completion: nil)
        
        UIView.animate(withDuration: 0.0, delay: animationDuration, options: [], animations: {
            self.XView.alpha = 0.0
            self.tableViewBg.alpha = 0.0
            self.triangleLayer?.removeFromSuperlayer()
            self.triangleLayer = nil
        }, completion: nil)
        
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
        inputTextField.becomeFirstResponder()
        if let selectedRange = inputTextField.selectedTextRange {
            let cursorPosition = inputTextField.offset(from: inputTextField.beginningOfDocument, to: selectedRange.start)
            
            print(cursorPosition)
            let index = inputTextField.text!.index(inputTextField.text!.startIndex, offsetBy: cursorPosition)
            let character = sender.titleLabel!.text!.firstCharacter()
            
            inputTextField.text?.insert(character, at: index)
            
            if let newCursorPosition = inputTextField.position(from: selectedRange.start, offset: 1) {
                inputTextField.selectedTextRange = inputTextField.textRange(from: newCursorPosition, to: newCursorPosition)
            }
        }

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
        XView.setValuesForLinearGradient(color1: UIColor.white, color2: GREEN_COLOR, startPoint: CGPoint(x: XView.frame.width / 2, y: 0.0), endPoint: CGPoint(x: XView.frame.width / 2, y: XView.frame.height / 2))
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

extension ConversionVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unitTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UnitCell", for: indexPath) as! UnitCell
        let unit = unitTypes[indexPath.row]
        cell.update(unit: unit, abb: unitAbbreviations[unit] ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch selectingUnit {
        case .input:
            let unit = unitTypes[indexPath.row]
            inputUnitLbl.text = unit.capitalized
            
            let abb = unitAbbreviations[unit] ?? ""
            if let abbreviation = abb as? NSMutableAttributedString {
                inputUnitSymbol.attributedText = abbreviation
            } else {
                inputUnitSymbol.text = abb as? String
            }
            
            
        case .output:
            let unit = unitTypes[indexPath.row]
            outputUnitLbl.text = unit.capitalized
            
            let abb = unitAbbreviations[unit] ?? ""
            if let abbreviation = abb as? NSMutableAttributedString {
                outputUnitSymbol.attributedText = abbreviation
            } else {
                outputUnitSymbol.text = abb as? String
            }
            
        default:
            break
        }
        
        removeTableView()
    }
}

