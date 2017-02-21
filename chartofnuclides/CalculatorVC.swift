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
    @IBOutlet weak var calculatorController: UISegmentedControl!
    @IBOutlet weak var particleTypeView: InspectableBorderView!
    @IBOutlet weak var particleTypeControl: UISegmentedControl!
    fileprivate var _selectedIsotope: Isotope?
    @IBOutlet weak var isotopeBtn: UIButton!
    
    var selectedIsotope: Isotope?
    
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
        
        // check if an isotope has been selected 
        if let isotope = _selectedIsotope {
            var solution: String?
            switch calculatorController.selectedSegmentIndex {
            case 0:
                solution = isotope.calculateBindingEnergy()
                
            case 1:
                switch (particleTypeControl.selectedSegmentIndex) {
                case 0:
                    solution = isotope.calculateNSeparationEnergy()
                
                case 1:
                    solution = isotope.calculatePSeparationEnergy()
                    
                default:
                    break
                }
                
            default:
                break
            }
            
            evaluate(solution)
        }
    }
    
    @IBAction func calculatorTypeChanged(_ sender: Any) {
        switch calculatorController.selectedSegmentIndex {
        
        case 0:
            particleTypeView.isHidden = true
            
        case 1:
            particleTypeView.isHidden = false
            
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PopupSearchVC {
            destination.delegate = self
        }
    }
    
    @IBAction func particleTypeChanged(_ sender: Any) {
        // may not need this
    }
    
    func evaluate(_ solution: String?) {
        if let solution = solution {
            print(solution)
            if solution.contains("Cannot") {
                solutionLbl.text = solution
                solutionLbl.font = UIFont(name: "Avenir-Medium", size: 20)
                solutionLbl.textColor = solutionView.colorWithHexString(hex: "CFCFCF")
                solutionView.changeBorderColor(to: solutionView.colorWithHexString(hex: "CFCFCF"))
                
            } else {
                solutionLbl.font = UIFont(name: "Avenir-Medium", size: 32)
                solutionLbl.text = "\(Double(solution)!.roundedTo(places: 4)) MeV"
                solutionLbl.textColor = GREEN_COLOR
                solutionView.changeBorderColor(to: GREEN_COLOR)
            }
        }
    }
}

extension CalculatorVC: SendDataToPreviousControllerDelegate {
    func sendDataToA(data: Any) {
        if let selectedIsotope = data as? Isotope {
            self._selectedIsotope = selectedIsotope
            isotopeBtn.setTitle("\(_selectedIsotope!.element.symbol)\(_selectedIsotope!.atomicNumber)", for: UIControlState.normal)
        }
    }
}
