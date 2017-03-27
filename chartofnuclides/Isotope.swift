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
    private var _spin: String!
    private var _fissionYield: String!
    private var _indFissionYield: String!
    private var _crossSection: String!
    private var _gammaEnergies = [String]()
    private var _decayModes = Dictionary<String, String>()
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
    
    var spin: String {
        return _spin
    }
    
    var fissionyield: String {
        return _fissionYield
    }
    
    var indFissionYield: String {
        return _indFissionYield
    }
    
    var crossSection: String {
        return _crossSection
    }
    
    var gammaEnergies: [String] {
        return _gammaEnergies
    }
    
    var decayModes: Dictionary<String, String> {
        return _decayModes
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
        
        if var abundance = isotope["abundance"] as? String {
            let valueInParenthesis = abundance.textInParentheses()
            if valueInParenthesis.count > 0 {
                let ending = abundance.components(separatedBy: ")").last
                var value = valueInParenthesis[0].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                value.stripUncertainty()
                self._abundance = value.appending(ending!)
            } else {
                abundance.stripUncertainty()
                self._abundance = abundance
            }
        }
        
        if let hasIsomer = isotope["has_isomer"] as? String {
            self._hasIsomer = hasIsomer
        }
        
        if let spin = isotope["spin"] as? String {
            self._spin = spin
        }
        
        if let fissionYield = isotope["cumulative fission yield"] as? String {
            self._fissionYield = fissionYield
        }
        
        if let indFissionYield = isotope["independent fission yield"] as? String {
            self._indFissionYield = indFissionYield
        }
        
        if let crossSection = isotope["crossSection"] as? String {
            self._crossSection = crossSection
        }
        
        if let gammaEnergies = isotope["gammaEnergies"] as? [Dictionary<String, AnyObject>] {
            for energy in gammaEnergies {
                if let energyValue = energy["energy"] as? String {
                    self._gammaEnergies.append(energyValue)
                }
            }
        }
        
        if let decayModes = isotope["decayModes"] as? [Dictionary<String, AnyObject>] {
            for modeDict in decayModes {
                if let type = modeDict["type"] as? String {
                    if let qValue = modeDict["Q-value"] as? String {
                        self._decayModes[type] = qValue
                    }
                }
            }
        }
        
        self._index = index
        
        self.element = element
        
    }
    
    func calculatePSeparationEnergy() -> String {
        
        let secondaryIsotope = ElementManager.instance.getIsotope(A: Int(atomicNumber)! - 1, Z: Int(element.protons)! - 1)
        
        if let secondIsotope = secondaryIsotope {
            let massY = Double(secondIsotope.mass)!
            let energy = C_2 * (massY + MASS_HYDROGEN - Double(mass)!)
            return "\(energy)"
        } else {
            return "Cannot calculate separation energy"
        }
    }
    
    func calculateNSeparationEnergy() -> String {
  
        let secondaryIsotope = ElementManager.instance.getIsotope(A: Int(atomicNumber)! - 1, Z: Int(element.protons)!)
        
        if let secondIsotope = secondaryIsotope {
            let secondMass = Double(secondIsotope.mass)!
            print(secondMass)
            let energy = C_2 * (secondMass + MASS_NEUTRON - Double(mass)!)
            return "\(energy)"
        } else {
            return "Cannot calculate separation energy"
        }
    
    }
    
    func calculateBindingEnergy() -> String {
        let BE = (C_2 * (Double(element.protons)! * (MASS_HYDROGEN) + Double(neutrons)! * MASS_NEUTRON - Double(mass)!))
        assert(BE >= 0.0)
        return "\(BE)"
    }
}
