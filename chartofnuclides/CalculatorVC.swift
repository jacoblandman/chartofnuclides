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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if view.frame.width < 374 {
            radiationSymbolImg.isHidden = true
        }
        
    }
    
    @IBAction func selectIsotopePressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "PopupSearch")
        popupVC.modalPresentationStyle = UIModalPresentationStyle.popover
        popupVC.popoverPresentationController?.sourceRect = (sender as! UIButton).frame
        popupVC.popoverPresentationController?.sourceView = (sender as! UIButton)
        popupVC.popoverPresentationController?.delegate = self
        popupVC.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        // 623 is height - navHeight - tabHeight
        popupVC.preferredContentSize = CGSize(width: 414, height: 100)
        popupVC.popoverPresentationController?.popoverLayoutMargins = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: -10)

        
        present(popupVC, animated: true, completion: nil)
    
    }

    @IBAction func calculatePressed(_ sender: Any) {
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
//    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
//        let navigationController = UINavigationController(rootViewController: controller.presentedViewController)
//        let btnDone = UIBarButtonItem(title: "Done", style: .done, target: self, action: "dismiss")
//        navigationController.topViewController?.navigationItem.rightBarButtonItem = btnDone
//        return navigationController
//    }
//    
//    func dismiss() {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
    
}
