//
//  ViewController.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/2/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var elements = [Element]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        elements = DataService.instance.parse_json()
        
        for element in elements {
            print("Element name: \(element.name)")
        }
    }
}

