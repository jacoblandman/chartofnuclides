//
//  DetailNuclideVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/14/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class DetailNuclideVC: UIViewController {

    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            //self.hideView.layoutIfNeeded()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func donePressed(_ sender: Any) {
        leadingConstraint.constant = 0
        dismiss(animated: true, completion: nil)
    }

}
