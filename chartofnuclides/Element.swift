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
    private var _index: Int!
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
    
    var index: Int {
        return _index
    }
    
    init(name: String, protons: String, symbol: String, mass: String, isotopes: [Isotope], elementIndex: Int) {
        self._name = name
        self._protons = protons
        self._symbol = symbol
        self._mass = mass
        self._isotopes = isotopes
        self._index = elementIndex
    }
    
    init(element: Dictionary<String, Any>, elementIndex: Int) {
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
            for (index, isotopeDict) in isotopes.enumerated() {
                _isotopes.append(Isotope(isotope: isotopeDict, at: index, from: self))
                DataService.instance.numberOfIsotopes = DataService.instance.numberOfIsotopes + 1
            }
        }
        
        self._index = elementIndex
        
        filteredIsotopes = _isotopes
    }
    
    func removeIsotopes() {
        self._isotopes = []
    }
    
    func addIsotope(isotope: Isotope) {
        self._isotopes.append(isotope)
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Element(name: _name, protons: _protons, symbol: _symbol, mass: _mass, isotopes: _isotopes, elementIndex: _index)
        return copy
    }
    
    
}
