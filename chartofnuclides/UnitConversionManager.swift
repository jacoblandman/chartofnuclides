//
//  UnitConversionManager.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/23/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import HHUnitConverter

class UnitConversionManager: HHUnitConverter {
        
    func setConversionRules() {
        setAngleRules()
        setLengthRules()
        setAreaRules()
        setVolumeRules()
        setMassRules()
        setTimeRules()
        setDensityRules()
    }
    
    private func setAngleRules() {
        self.letUnit("degrees", convertToUnit: "radians", byMultiplyingBy: 1.745329E-2)
        self.letUnit("grades", convertToUnit: "radians", byMultiplyingBy: 1.570796E-2)
        self.letUnit("minutes", convertToUnit: "radians", byMultiplyingBy: 2.908882E-4)
        self.letUnit("seconds", convertToUnit: "radians", byMultiplyingBy: 4.848137E-6)
        self.letUnit("solid angle", convertToUnit: "steradians", byMultiplyingBy: 1.256637E1)
        self.letUnit("square degrees", convertToUnit: "steradians", byMultiplyingBy: 3.046174E-4)
    }
    
    private func setLengthRules() {
        
        // meters from other units
        self.letUnit("angstroms", convertToUnit: "meters", byMultiplyingBy: 1E-10)
        self.letUnit("astronomical units", convertToUnit: "meters", byMultiplyingBy: 1.495979E11)
        self.letUnit("feet", convertToUnit: "meters", byMultiplyingBy: 3.048E-01)
        self.letUnit("inches", convertToUnit: "meters", byMultiplyingBy: 2.54E-02)
        self.letUnit("light years", convertToUnit: "meters", byMultiplyingBy: 9.460730E15)
        self.letUnit("mils", convertToUnit: "meters", byMultiplyingBy: 2.54E-5)
        self.letUnit("miles", convertToUnit: "meters", byMultiplyingBy: 1.609344E3)
        self.letUnit("nautical miles", convertToUnit: "meters", byMultiplyingBy: 1.852E3)
        self.letUnit("parsecs", convertToUnit: "meters", byMultiplyingBy: 3.085678E16)
        self.letUnit("yards", convertToUnit: "meters", byMultiplyingBy: 9.144E-01)
        
        // meters from U.S. survey units
        self.letUnit("links", convertToUnit: "meters", byMultiplyingBy: 2.011684E-1)
        self.letUnit("survey feet", convertToUnit: "meters", byMultiplyingBy: 3.048006E-1)
        self.letUnit("rods", convertToUnit: "meters", byMultiplyingBy: 5.029210)
        self.letUnit("chains", convertToUnit: "meters", byMultiplyingBy: 2.011684E1)
        self.letUnit("statute miles", convertToUnit: "meters", byMultiplyingBy: 1.609347E3)
        
        // others
        self.letUnit("furlongs", convertToUnit: "survey feet", byMultiplyingBy: 660)
        
        // si conversion
        self.letUnit("yottameters", convertToUnit: "meters", byMultiplyingBy: 1E24)
        self.letUnit("zettameters", convertToUnit: "meters", byMultiplyingBy: 1E21)
        self.letUnit("exameters", convertToUnit: "meters", byMultiplyingBy: 1E18)
        self.letUnit("petameters", convertToUnit: "meters", byMultiplyingBy: 1E15)
        self.letUnit("terameters", convertToUnit: "meters", byMultiplyingBy: 1E12)
        self.letUnit("gigameters", convertToUnit: "meters", byMultiplyingBy: 1E9)
        self.letUnit("megameters", convertToUnit: "meters", byMultiplyingBy: 1E6)
        self.letUnit("kilometers", convertToUnit: "meters", byMultiplyingBy: 1E3)
        self.letUnit("hectometers", convertToUnit: "meters", byMultiplyingBy: 1E2)
        self.letUnit("dekameters", convertToUnit: "meters", byMultiplyingBy: 1E1)
        self.letUnit("decimeters", convertToUnit: "meters", byMultiplyingBy: 1E-1)
        self.letUnit("centimeters", convertToUnit: "meters", byMultiplyingBy: 1E-2)
        self.letUnit("millimeters", convertToUnit: "meters", byMultiplyingBy: 1E-3)
        self.letUnit("micrometers", convertToUnit: "meters", byMultiplyingBy: 1E-6)
        self.letUnit("nanometers", convertToUnit: "meters", byMultiplyingBy: 1E-9)
        self.letUnit("picometers", convertToUnit: "meters", byMultiplyingBy: 1E-12)
        self.letUnit("femtometers", convertToUnit: "meters", byMultiplyingBy: 1E-15)
        self.letUnit("attometers", convertToUnit: "meters", byMultiplyingBy: 1E-18)
        self.letUnit("zeptometers", convertToUnit: "meters", byMultiplyingBy: 1E-21)
        self.letUnit("yoctometers", convertToUnit: "meters", byMultiplyingBy: 1E-24)
        
    }
    
    private func setAreaRules() {
        
        // square meters from other units
        self.letUnit("barns", convertToUnit: "square meters", byMultiplyingBy: 1.0E-28)
        self.letUnit("circular mils", convertToUnit: "square meters", byMultiplyingBy: 5.067075E-10)
        self.letUnit("hectares", convertToUnit: "square meters", byMultiplyingBy: 1E4)
        self.letUnit("square feet", convertToUnit: "square meters", byMultiplyingBy: 9.290304E-2)
        self.letUnit("square inches", convertToUnit: "square meters", byMultiplyingBy: 6.4516E-4)
        self.letUnit("square miles", convertToUnit: "square meters", byMultiplyingBy: 2.589988E6)
        self.letUnit("square yards", convertToUnit: "square meters", byMultiplyingBy: 8.361274E-1)
        
        // square meters from U.S. survey units
        self.letUnit("square survey feet", convertToUnit: "square meters", byMultiplyingBy: 9.290341E-2)
        self.letUnit("square rods", convertToUnit: "square meters", byMultiplyingBy: 2.529295E1)
        self.letUnit("square chains", convertToUnit: "square meters", byMultiplyingBy: 4.046873E2)
        self.letUnit("acres", convertToUnit: "square meters", byMultiplyingBy: 4.046873E3)
        self.letUnit("square survey miles", convertToUnit: "square meters", byMultiplyingBy: 2.589998E6)
        
        // others
        self.letUnit("circular mils", convertToUnit: "circular inches", byMultiplyingBy: 1E-6)
        self.letUnit("circular mils", convertToUnit: "square mils", byMultiplyingBy: 7.853982E-1)
        
        // si conversion
//        self.letUnit("square yottameter", convertToUnit: "square meter", byMultiplyingBy: (1E24*1E24))
//        self.letUnit("square zettameter", convertToUnit: "square meter", byMultiplyingBy: 1E21*1E21)
//        self.letUnit("square exameter", convertToUnit: "square meter", byMultiplyingBy: 1E18*1E18)
//        self.letUnit("square petameter", convertToUnit: "square meter", byMultiplyingBy: 1E15*1E15)
//        self.letUnit("square terameter", convertToUnit: "square meter", byMultiplyingBy: 1E12*1E12)
//        self.letUnit("square gigameter", convertToUnit: "square meter", byMultiplyingBy: 1E9*1E9)
//        self.letUnit("square megameter", convertToUnit: "square meter", byMultiplyingBy: 1E6*1E6)
        self.letUnit("square kilometers", convertToUnit: "square meters", byMultiplyingBy: 1E3*1E3)
        self.letUnit("square hectometers", convertToUnit: "square meters", byMultiplyingBy: 1E2*1E2)
        self.letUnit("square dekameters", convertToUnit: "square meters", byMultiplyingBy: 1E1*1E1)
        self.letUnit("square decimeters", convertToUnit: "square meters", byMultiplyingBy: 1E-1*1E-1)
        self.letUnit("square centimeters", convertToUnit: "square meters", byMultiplyingBy: 1E-2*1E-2)
        self.letUnit("square millimeters", convertToUnit: "square meters", byMultiplyingBy: 1E-3*1E-3)
        self.letUnit("square micrometers", convertToUnit: "square meters", byMultiplyingBy: 1E-6*1E-6)
        self.letUnit("square nanometers", convertToUnit: "square meters", byMultiplyingBy: 1E-9*1E-9)
//        self.letUnit("square picometer", convertToUnit: "square meter", byMultiplyingBy: 1E-12*1E-12)
//        self.letUnit("square femtometer", convertToUnit: "square meter", byMultiplyingBy: 1E-15*1E-15)
//        self.letUnit("square attometer", convertToUnit: "square meter", byMultiplyingBy: 1E-18*1E-18)
//        self.letUnit("square zeptometer", convertToUnit: "square meter", byMultiplyingBy: 1E-21*1E-21)
//        self.letUnit("square yoctometer", convertToUnit: "square meter", byMultiplyingBy: 1E-24*1E-24)
        
    }
    
    private func setVolumeRules() {
        
        // cubic meter from other units
        self.letUnit("cubic feet", convertToUnit: "cubic meters", byMultiplyingBy: 2.831685E-2)
        self.letUnit("cubic inches", convertToUnit: "cubic meters", byMultiplyingBy: 1.6387064E-5)
        self.letUnit("cubic yards", convertToUnit: "cubic meters", byMultiplyingBy: 7.645549E-1)
        self.letUnit("liters", convertToUnit: "cubic meters", byMultiplyingBy: 1E-3)
        self.letUnit("steres", convertToUnit: "cubic meters", byMultiplyingBy: 1.0)
        
        // cubic meter from other units of dry volume measure
        self.letUnit("dry pints", convertToUnit: "cubic meters", byMultiplyingBy: 5.506105E-4)
        self.letUnit("dry quarts", convertToUnit: "cubic meters", byMultiplyingBy: 1.101221E-3)
        self.letUnit("pecks", convertToUnit: "cubic meters", byMultiplyingBy: 8.809768E-3)
        self.letUnit("bushels", convertToUnit: "cubic meters", byMultiplyingBy: 3.523907E-2)
        
        // cubic meter from other units of liquid volume measure
        self.letUnit("fluid ounces", convertToUnit: "cubic meters", byMultiplyingBy: 2.957353E-5)
        self.letUnit("liquid pints", convertToUnit: "cubic meters", byMultiplyingBy: 4.731765E-4)
        self.letUnit("liquid quarts", convertToUnit: "cubic meters", byMultiplyingBy: 9.463529E-4)
        self.letUnit("gallons", convertToUnit: "cubic meters", byMultiplyingBy: 3.785412E-3)
        
        // si conversion
        self.letUnit("cubic gigameters", convertToUnit: "cubic meters", byMultiplyingBy: 1E9*1E9*1E9)
        self.letUnit("cubic megameters", convertToUnit: "cubic meters", byMultiplyingBy: 1E6*1E6*1E6)
        self.letUnit("cubic kilometers", convertToUnit: "cubic meters", byMultiplyingBy: 1E3*1E3*1E3)
        self.letUnit("cubic hectometers", convertToUnit: "cubic meters", byMultiplyingBy: 1E2*1E2*1E2)
        self.letUnit("cubic dekameters", convertToUnit: "cubic meters", byMultiplyingBy: 1E1*1E1*1E1)
        self.letUnit("cubic decimeters", convertToUnit: "cubic meters", byMultiplyingBy: 1E-1*1E-1*1E-1)
        self.letUnit("cubic centimeters", convertToUnit: "cubic meters", byMultiplyingBy: 1E-2*1E-2*1E-2)
        self.letUnit("cubic millimeters", convertToUnit: "cubic meters", byMultiplyingBy: 1E-3*1E-3*1E-3)
        self.letUnit("cubic micrometers", convertToUnit: "cubic meters", byMultiplyingBy: 1E-6*1E-6*1E-6)
        self.letUnit("cubic nanometers", convertToUnit: "cubic meters", byMultiplyingBy: 1E-9*1E-9*1E-9)
    }
    
    private func setMassRules() {
        
        // to kilograms from avoirdupois units
        self.letUnit("grains", convertToUnit: "kilograms", byMultiplyingBy: 6.479891E-5)
        self.letUnit("drams", convertToUnit: "kilograms", byMultiplyingBy: 1.771845E-3)
        self.letUnit("ounces", convertToUnit: "kilograms", byMultiplyingBy: 2.834952E-2)
        self.letUnit("pounds", convertToUnit: "kilograms", byMultiplyingBy: 4.5359237E-1)
//        self.letUnit("short hundredweight", convertToUnit: "kilogram", byMultiplyingBy: 4.535924E1)
        self.letUnit("short tons", convertToUnit: "kilograms", byMultiplyingBy: 9.071847E2)
        self.letUnit("stones", convertToUnit: "kilograms", byMultiplyingBy: 6.350293)
//        self.letUnit("long hundredweight", convertToUnit: "kilogram", byMultiplyingBy: 5.080235E1)
//        self.letUnit("long ton", convertToUnit: "kilogram", byMultiplyingBy: 1.016047E3)
        self.letUnit("metric tons", convertToUnit: "kilograms", byMultiplyingBy: 1E3)
        self.letUnit("tonnes", convertToUnit: "kilograms", byMultiplyingBy: 1E3)
        
        // to kilograms from apothecary units
//        self.letUnit("apothecary grain", convertToUnit: "kilogram", byMultiplyingBy: 6.479891E-5)
//        self.letUnit("scruple", convertToUnit: "kilogram", byMultiplyingBy: 1.295978E-3)
//        self.letUnit("apothecary dram", convertToUnit: "kilogram", byMultiplyingBy: 3.887935E-3)
//        self.letUnit("apothecary ounce", convertToUnit: "kilogram", byMultiplyingBy: 3.887935E-3)
//        self.letUnit("apothecary pound", convertToUnit: "kilogram", byMultiplyingBy: 3.732417E-1)
        
        // to kilograms from troy units
//        self.letUnit("troy grain", convertToUnit: "kilogram", byMultiplyingBy: 6.479891E-5)
//        self.letUnit("pennyweight", convertToUnit: "kilogram", byMultiplyingBy: 1.555174E-3)
//        self.letUnit("troy ounce", convertToUnit: "kilogram", byMultiplyingBy: 3.110348E-2)
//        self.letUnit("troy pound", convertToUnit: "kilogram", byMultiplyingBy: 3.732417E-1)
        
        // other unit conversions
        self.letUnit("grams", convertToUnit: "kilograms", byMultiplyingBy: 1E-3)
        
    }
    
    private func setTimeRules() {
        
        // to seconds from other units
        self.letUnit("minutes", convertToUnit: "seconds", byMultiplyingBy: 6E1)
        self.letUnit("hours", convertToUnit: "seconds", byMultiplyingBy: 3.6E3)
        self.letUnit("days", convertToUnit: "seconds", byMultiplyingBy: 8.64E4)
        self.letUnit("years", convertToUnit: "seconds", byMultiplyingBy: 3.1536E7)
        self.letUnit("shakes", convertToUnit: "seconds", byMultiplyingBy: 1E-8)
    }
    
    private func setDensityRules() {
        self.letUnit("grams per cubic centimeter", convertToUnit: "kilograms per cubic meter", byMultiplyingBy: 1E3)
        self.letUnit("pounds per cubic foot", convertToUnit: "kilograms per cubic meter", byMultiplyingBy: 1.601846E1)
        self.letUnit("pounds per cubic inch", convertToUnit: "kilograms per cubic meter", byMultiplyingBy: 2.767990E4)
        self.letUnit("grams per cubic meter", convertToUnit: "kilograms per cubic meter", byMultiplyingBy: 1E-3)
        self.letUnit("kilograms per cubic centimeter", convertToUnit: "kilograms per cubic meter", byMultiplyingBy: 1E6)

    }
    
}
