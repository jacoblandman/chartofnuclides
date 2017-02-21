//
//  ElementManager.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/21/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import Foundation

class ElementManager: NSObject {
    
    static let instance = ElementManager()
    
    private var _elements: [Element]
    
    var elements: [Element] {
        return _elements
    }
    
    override init() {
        _elements = DataService.instance.parse_json()
    }
    
}
