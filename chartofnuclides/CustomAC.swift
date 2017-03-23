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
    @IBOutlet weak var toolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        toolBar.isTranslucent = true
    }
    
    @IBAction func yesPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func noPressed(_ sender: Any) {
    }
}
