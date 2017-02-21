//
//  CalculatorVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/14/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class CalculatorVC: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var solutionView: InspectableBorderView!
    @IBOutlet weak var solutionLbl: UILabel!
    @IBOutlet weak var radiationSymbolImg: UIImageView!
    @IBOutlet weak var calculateBtn: RadialGradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if view.frame.width < 374 {
            radiationSymbolImg.isHidden = true
        }
        
    }
    
    @IBAction func selectIsotopePressed(_ sender: Any) {
        
        performSegue(withIdentifier: "PopupSearchVC", sender: nil)
    
    }

    @IBAction func calculatePressed(_ sender: Any) {
    }
    
}
