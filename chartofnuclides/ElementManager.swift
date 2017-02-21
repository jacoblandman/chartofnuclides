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
    
    // this function can return nil if a person tries to get an isotope that doesn't exist
    // i.e. unphysical values for A,Z
    func getIsotope(A: Int, Z: Int) -> Isotope? {
        
        // there are no elements lower than hydrogen
        guard ( Z > 0 && Z < 119 ) else { return nil }
        
        let element = _elements[Z-1]
        for isotope in element.isotopes {
            if isotope.atomicNumber == "\(A)" {
                return isotope
            }
        }
        
        return nil
    }
    
}
