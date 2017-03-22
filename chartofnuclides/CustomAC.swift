//
//  CustomAC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/22/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class CustomAC: UIViewController {

    @IBOutlet weak var alertTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func yesPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func noPressed(_ sender: Any) {
    }

}
