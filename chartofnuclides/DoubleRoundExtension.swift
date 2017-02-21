//
//  DoubleRoundExtension.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/21/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

extension Double {
    
    func roundedTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
