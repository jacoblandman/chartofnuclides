//
//  Element.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/3/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class Element {
    
    private var _name: String!
    private var _protons: String!
    private var _symbol: String!
    private var _mass: String!
    private var _isotopes = [Isotope]()
    
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
        
        if let isotopes = element["isotopes"] as? [Dictionary<String, Any>] {
            for isotopeDict in isotopes {
                _isotopes.append(Isotope(isotope: isotopeDict))
            }
        }
        
    }
    
    
}
