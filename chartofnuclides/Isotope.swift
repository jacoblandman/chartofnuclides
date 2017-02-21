//
//  Isotope.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/3/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class Isotope {
    
    weak var element: Element!
    
    private var _atomicNumber: String!
    private var _neutrons: String!
    private var _mass: String!
    private var _halfLife: String!
    private var _abundance: String!
    private var _hasIsomer: String!
    private var _isStable: String!
    private var _index: Int!
    
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
    
    var index: Int {
        return _index
    }
    
    init(isotope: Dictionary<String, Any>, at index: Int, from element: Element) {
        if let atomicNumber = isotope["atomic number"] as? String {
            self._atomicNumber = atomicNumber
        }
        
        if let neutrons = isotope["neutrons"] as? String {
            self._neutrons = neutrons
        }
        
        if var mass = isotope["weight"] as? String {
            mass.stripUncertainty()
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
        
        self._index = index
        
        self.element = element
        
    }
    
    func calculatePSeparationEnergy() -> String {
        
        let secondaryIsotope = ElementManager.instance.getIsotope(A: Int(atomicNumber)! - 1, Z: Int(element.protons)! - 1)
        
        if let secondIsotope = secondaryIsotope {
            let massY = Double(secondIsotope.mass)!
            let energy = C_2 * (massY + MASS_HYDROGEN - Double(mass)!)
            if energy > 0 { return "\(energy)" }
            else { return "Cannot calculate separation energy" }
        } else {
            return "Cannot calculate separation energy"
        }
    }
    
    func calculateNSeparationEnergy() -> String {
  
        let secondaryIsotope = ElementManager.instance.getIsotope(A: Int(atomicNumber)! - 1, Z: Int(element.protons)!)
        
        if let secondIsotope = secondaryIsotope {
            let secondMass = Double(secondIsotope.mass)!
            let energy = C_2 * (secondMass + MASS_NEUTRON - Double(mass)!)
            if energy > 0 { return "\(energy)" }
            else { return "Cannot calculate separation energy" }
        } else {
            return "Cannot calculate separation energy"
        }
    
    }
    
    func calculateBindingEnergy() -> String {
        let BE = (C_2 * (Double(element.protons)! * MASS_HYDROGEN + Double(neutrons)! * MASS_NEUTRON - Double(mass)!))
        assert(BE > 0.0)
        return "\(BE)"
    }
    
}
