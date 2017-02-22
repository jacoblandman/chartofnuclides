//
//  UnitConversionManager.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/22/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

class UnitConversionManager: NSObject {
    
    static let instance = UnitConversionManager()
    
    private var _unitTypes = ["Angle", "Length", "Area", "Volume", "Mass", "Time", "Density", "Velocity", "Angular Velocity", "Acceleration",
                              "Force", "Work", "Power", "Torque", "Temperature", "Pressure", "Electromagnitism", "Magnetics", "Radiation"]
    
    private var _unitTypesDict: Dictionary<String, [String]>
    
    private var _angleTypes = ["degree", "radian", "grade", "minute", "second", "solid angle", "square degree", "steradians"]
    private var _lengthTypes = ["degree", "radian", "grade", "minute", "second", "solid angle", "square degree", "steradians"]
    private var _areaTypes = ["degree", "radian", "grade", "minute", "second", "solid angle", "square degree", "steradians"]
    private var _volumeTypes = ["degree", "radian", "grade", "minute", "second", "solid angle", "square degree", "steradians"]
    private var _massTypes = ["degree", "radian", "grade", "minute", "second", "solid angle", "square degree", "steradians"]
    private var _timeTypes = ["degree", "radian", "grade", "minute", "second", "solid angle", "square degree", "steradians"]
    private var _densityTypes = ["degree", "radian", "grade", "minute", "second", "solid angle", "square degree", "steradians"]
    private var _velocityTypes = ["degree", "radian", "grade", "minute", "second", "solid angle", "square degree", "steradians"]
    private var _angularvelocityTypes = ["degree", "radian", "grade", "minute", "second", "solid angle", "square degree", "steradians"]
    private var _accelerationTypes = ["degree", "radian", "grade", "minute", "second", "solid angle", "square degree", "steradians"]
    private var _forceTypes = ["degree", "radian", "grade", "minute", "second", "solid angle", "square degree", "steradians"]
    private var _workTypes = ["degree", "radian", "grade", "minute", "second", "solid angle", "square degree", "steradians"]
    private var _powerTypes = ["degree", "radian", "grade", "minute", "second", "solid angle", "square degree", "steradians"]
    private var _torqueTypes = ["degree", "radian", "grade", "minute", "second", "solid angle", "square degree", "steradians"]
    private var _temperatureTypes = ["degree", "radian", "grade", "minute", "second", "solid angle", "square degree", "steradians"]
    private var _pressureTypes = ["degree", "radian", "grade", "minute", "second", "solid angle", "square degree", "steradians"]
    private var _electromagnitismTypes = ["degree", "radian", "grade", "minute", "second", "solid angle", "square degree", "steradians"]
    private var _magneticsTypes = ["degree", "radian", "grade", "minute", "second", "solid angle", "square degree", "steradians"]
    private var _radiationTypes = ["degree", "radian", "grade", "minute", "second", "solid angle", "square degree", "steradians"]
    
    override init() {
        _unitTypesDict = ["Angle": _angleTypes, "Length": _lengthTypes, "Area": _areaTypes, "Volume": _volumeTypes,
                          "Mass": _massTypes, "Time": _timeTypes, "Density": _densityTypes, "Velocity": _velocityTypes,
                          "Angular Velocity": _angularvelocityTypes, "Acceleration": _accelerationTypes, "Force": _forceTypes,
                          "Work": _workTypes, "Power": _powerTypes, "Torque": _torqueTypes, "Temperature": _temperatureTypes,
                          "Pressure": _pressureTypes, "Electromagnitism": _electromagnitismTypes, "Magnetics": _magneticsTypes,
                          "Radiation": _radiationTypes]

    }
    
    var unitTypes: [String] {
        return _unitTypes
    }
    
    var unitTypesDict: Dictionary<String, [String]> {
        return _unitTypesDict
    }
    
}
