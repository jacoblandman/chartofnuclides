//
//  Isotope.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/3/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class Isotope {
    
    private var _atomicNumber: String!
    private var _neutrons: String!
    private var _mass: String!
    private var _halfLife: String!
    private var _abundance: String!
    private var _hasIsomer: String!
    private var _isStable: String!
    
    var atomicNumber: String {
        return _atomicNumber
    }
    
    var neutrons: String {
        return _neutrons
    }
    
    var mass: String {
        return _mass
    }
    
    var halfLife: String {
        return _halfLife
    }
    
    var abundance: String {
        return _abundance
    }
    
    var hasIsomer: String {
        return _hasIsomer
    }
    
    var isStable: String {
        return _isStable
    }
    
    init(atomicNumber: String, neutrons: String, mass: String,
         halfLife: String, abundance: String, hasIsomer: String, isStable: String ) {
        self._atomicNumber = atomicNumber
        self._neutrons = neutrons
        self._mass = mass
        self._halfLife = halfLife
        self._abundance = abundance
        self._hasIsomer = hasIsomer
        self._isStable = isStable
    }
    
    init(isotope: Dictionary<String, Any>) {
        if let atomicNumber = isotope["atomic number"] as? String {
            self._atomicNumber = atomicNumber
        }
        
        if let neutrons = isotope["neutrons"] as? String {
            self._neutrons = neutrons
        }
        
        if let mass = isotope["weight"] as? String {
            self._mass = mass
        }
        
        if let halfLife = isotope["half-life"] as? String {
            self._halfLife = halfLife
        }
        
        if let isStable = isotope["stable"] as? String {
            self._isStable = isStable
        }
        
        if let abundance = isotope["abundance"] as? String {
            self._abundance = abundance
        }
        
        if let hasIsomer = isotope["has_isomer"] as? String {
            self._hasIsomer = hasIsomer
        }
        
    }
    
}
