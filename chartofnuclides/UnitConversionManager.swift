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
    }
    
    private func setAngleRules() {
        self.letUnit("degree", convertToUnit: "radian", byMultiplyingBy: 1.745329E-2)
        self.letUnit("grade", convertToUnit: "radian", byMultiplyingBy: 1.570796E-2)
        self.letUnit("minute", convertToUnit: "radian", byMultiplyingBy: 2.908882E-4)
        self.letUnit("second", convertToUnit: "radian", byMultiplyingBy: 4.848137E-6)
        self.letUnit("solid angle", convertToUnit: "steradians", byMultiplyingBy: 1.256637E1)
        self.letUnit("square degree", convertToUnit: "steradians", byMultiplyingBy: 3.046174E-4)
    }
}
