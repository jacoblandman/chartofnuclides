//
//  IsotopeGuideVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/28/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class IsotopeGuideVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    // labels in the view
    @IBOutlet weak var bottomBgView: UIView!
    @IBOutlet weak var massLbl: UILabel!
    @IBOutlet weak var decayModeBracket: UILabel!
    @IBOutlet weak var gammaEnergyLbl: UILabel!
    @IBOutlet weak var crossSectionLbl: UILabel!
    @IBOutlet weak var halfLifeLbl: UILabel!
    @IBOutlet weak var symbolLbl: UILabel!
    @IBOutlet weak var spinLbl: UILabel!
    
    // description labels
    @IBOutlet weak var backgroundDesc: UILabel!
    @IBOutlet var massDesc: UIView!
    @IBOutlet weak var halfLifeDesc: UILabel!
    @IBOutlet weak var spinDesc: UILabel!
    @IBOutlet weak var symbolDesc: UILabel!
    @IBOutlet weak var crossSectionDesc: UILabel!
    @IBOutlet weak var gammaEnergyDesc: UILabel!
    @IBOutlet weak var decayModeDesc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        drawLines()
    }
    
    func drawLines() {
        drawLine(from: decayModeBracket.frame, to: decayModeDesc.frame,
                 relativeStartPoint: CGPoint(x: 0, y: 0.5), relativeEndPoint: CGPoint(x: 0.5, y: 0.0),
                 startOffset: CGPoint(x: -2, y: 2.0), endOffset: CGPoint(x: 0.0, y: -2.0), needsConversion: false)
        
        drawLine(from: gammaEnergyLbl.frame, to: gammaEnergyDesc.frame,
                 relativeStartPoint: CGPoint(x: 0.0, y: 0.5), relativeEndPoint: CGPoint(x: 1.0, y: 0.5),
                 startOffset: CGPoint(x: -2, y: 0.0), endOffset: CGPoint(x: -2.0, y: 0.0), needsConversion: true)
        
        drawLine(from: crossSectionLbl.frame, to: crossSectionDesc.frame,
                 relativeStartPoint: CGPoint(x: 0.0, y: 0.5), relativeEndPoint: CGPoint(x: 0.5, y: 1.0),
                 startOffset: CGPoint(x: -2, y: 0.0), endOffset: CGPoint(x: 0.0, y: 2.0), needsConversion: true)
        
        drawLine(from: symbolLbl.frame, to: symbolDesc.frame,
                 relativeStartPoint: CGPoint(x: 0.5, y: 0.0), relativeEndPoint: CGPoint(x: 0.5, y: 1.0),
                 startOffset: CGPoint(x: 0, y: -2.0), endOffset: CGPoint(x: 0.0, y: 2.0), needsConversion: true)
        
        drawLine(from: spinLbl.frame, to: spinDesc.frame,
                 relativeStartPoint: CGPoint(x: 1.0, y: 0.0), relativeEndPoint: CGPoint(x: 0.5, y: 1.0),
                 startOffset: CGPoint(x: 1, y: -1.0), endOffset: CGPoint(x: -4.0, y: 2.0), needsConversion: true)
        
        drawLine(from: halfLifeLbl.frame, to: halfLifeDesc.frame,
                 relativeStartPoint: CGPoint(x: 1.0, y: 0.5), relativeEndPoint: CGPoint(x: 0.0, y: 0.5),
                 startOffset: CGPoint(x: -2, y: 0.0), endOffset: CGPoint(x: -4, y: 0.0), needsConversion: true)
        
        drawLine(from: bottomBgView.frame, to: backgroundDesc.frame,
                 relativeStartPoint: CGPoint(x: 0.8, y: 0.8), relativeEndPoint: CGPoint(x: 0.5, y: 0.0),
                 startOffset: CGPoint(x: 2, y: 0.0), endOffset: CGPoint(x: 0, y: -2.0), needsConversion: true)
        
        drawLine(from: massLbl.frame, to: massDesc.frame,
                 relativeStartPoint: CGPoint(x: 0.5, y: 1.0), relativeEndPoint: CGPoint(x: 0.5, y: 0.0),
                 startOffset: CGPoint(x: 2, y: 0.0), endOffset: CGPoint(x: -2, y: 0.0), needsConversion: true)
    }
    
    func drawLine(from frame1: CGRect, to frame2: CGRect,
                  relativeStartPoint: CGPoint, relativeEndPoint: CGPoint,
                  startOffset: CGPoint, endOffset: CGPoint, needsConversion: Bool) {
        
        var startPoint = CGPoint(x: frame1.minX + relativeStartPoint.x * frame1.width + startOffset.x ,
                                 y: frame1.minY + relativeStartPoint.y * frame1.height + startOffset.y)
        let endPoint = CGPoint(x: frame2.minX + relativeEndPoint.x * frame2.width + endOffset.x ,
                               y: frame2.minY + relativeEndPoint.y * frame2.height + endOffset.y)
        
        if needsConversion {
            startPoint = self.view.convert(startPoint, from: containerView)
        }
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        self.view.layer.addSublayer(shapeLayer)
    }
}
