//
//  UnitConversionTypeManager.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/22/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

class UnitConversionTypeManager: NSObject {
    
    static let instance = UnitConversionTypeManager()
    
    lazy var converter: UnitConversionManager = {
        let lazyConverter = UnitConversionManager()
        lazyConverter.setConversionRules()
        return lazyConverter
    }()
    
    private var _unitTypes = ["Angle", "Length", "Area", "Volume", "Mass", "Time", "Density", "Velocity", "Angular Velocity", "Acceleration",
                              "Force", "Work", "Power", "Torque", "Temperature", "Pressure", "Electromagnitism", "Magnetics", "Radiation"]
    
    private var _unitTypesDict: Dictionary<String, [String]>
    
    private var _angleTypes = ["degrees", "radians", "grades", "minutes", "seconds", "solid angle", "square degrees", "steradians"]
    
    private var _lengthTypes = ["angstroms", "meters", "astronomical units", "feet", "inches", "light years", "mils", "miles", "nautical miles", "parsecs",
                                "yards", "links", "survey feet", "rods", "chains", "statute miles", "furlongs", "yottameters", "zettameters",
                                "exameters", "petameters", "terameters", "gigameters", "megameters", "kilometers", "hectometers", "dekameters", "decimeters",
                                "centimeters", "millimeters", "micrometers", "nanometers", "picometers", "femtometers", "attometers", "zeptometers", "yoctometers"]
    
    private var _areaTypes = ["barns", "square meters", "circular mils", "hectares", "square feet", "square inches", "square miles", "square yards",
                              "square survey feet", "square rods", "square chains", "acres", "square survey miles", "circular inches", "square mils",
                              "square kilometers", "square hectometers", "square dekameters", "square decimeters", "square centimeters",
                              "square millimeters", "square micrometers", "square nanometers"]
    
    private var _volumeTypes = ["cubic feet", "cubic meters", "cubic inches", "cubic yards", "liters", "steres",
                                "dry pints", "dry quarts", "pecks", "bushels", "fluid ounces", "liquid pints",
                                "liquid quarts", "gallons", "cubic gigameters", "cubic megameters", "cubic kilometers",
                                "cubic hectometers", "cubic dekameters", "cubic decimeters", "cubic centimeters",
                                "cubic millimeters", "cubic micrometers", "cubic nanometers"]
    
    private var _massTypes = ["grams", "kilograms", "grains", "drams", "ounces", "pounds", "short tons", "stones", "metric tons", "tonnes"]
    
    private var _timeTypes = ["seconds", "minutes", "hours", "days", "years", "shakes"]
    
    private var _densityTypes = ["grams per cubic centimeter", "pounds per cubic foot", "pounds per cubic inch",
                                 "grams per cubic meter", "kilograms per cubic centimeter", "kilograms per cubic meter"]
    
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
