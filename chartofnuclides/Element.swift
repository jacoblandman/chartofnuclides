//
//  Element.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/3/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class Element: NSCopying {
    
    private var _name: String!
    private var _protons: String!
    private var _symbol: String!
    private var _mass: String!
    private var _isotopes = [Isotope]()
    var filteredIsotopes = [Isotope]()
    
    var name: String {
        return _name
    }
    
    var protons: String {
        return _protons
    }
    
    var symbol: String {
        return _symbol
    }
    
    var mass: String {
        return _mass
    }
    
    var isotopes: [Isotope] {
        return _isotopes
    }
    
    init(name: String, protons: String, symbol: String, mass: String, isotopes: [Isotope]) {
        self._name = name
        self._protons = protons
        self._symbol = symbol
        self._mass = mass
        self._isotopes = isotopes
    }
    
    init(element: Dictionary<String, Any>) {
        if let name = element["name"] as? String {
            self._name = name
        }
        
        if let protons = element["protons"] as? String {
            self._protons = protons
        }
        
        if let symbol = element["symbol"] as? String {
            self._symbol = symbol
        }
        if let mass = element["mass"] as? String {
            self._mass = mass
        }
        
        // this should work because by this point, all of Elements values have been instantiated
        // thus we can pass self to the Isotope for creation
        if let isotopes = element["isotopes"] as? [Dictionary<String, Any>] {
            for isotopeDict in isotopes {
                _isotopes.append(Isotope(isotope: isotopeDict, from: self))
            }
        }
        
        filteredIsotopes = _isotopes
    }
    
    func removeIsotopes() {
        self._isotopes = []
    }
    
    func addIsotope(isotope: Isotope) {
        self._isotopes.append(isotope)
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Element(name: _name, protons: _protons, symbol: _symbol, mass: _mass, isotopes: _isotopes)
        return copy
    }
    
    
}
