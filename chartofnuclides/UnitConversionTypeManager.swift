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
    
    private var _velocityTypes = ["feet per hour", "meters per second", "feet per minute", "feet per second", "inches per second", "kilometers per hour"]
    
    private var _angularvelocityTypes = ["revolutions per second", "radians per second", "revolutions per minute", "degrees per second"]
    
    private var _accelerationTypes = ["feet per second squared", "meters per second squared", "standard free fall", "inches per second squared", "centimeters per second squared"]
    
    private var _forceTypes = ["pounds-force", "newtons", "ounces-force", "poundals", "kips", "dynes"]
    
    private var _workTypes = ["electronvolts", "joules", "calories (15°C)", "calories (20°C)", "calories (mean)", "Btus (39°F)", "Btus (59°F)", "Btus (60°F)", "Btus (mean)",
                              "ergs", "feet poundals", "feet pounds-force", "kilowatt hours", "watt hours", "watt seconds", "tons (nuclear equivalent of TNT)"]
    
    private var _powerTypes = ["Btus (mean) per second", "watts", "ergs per second", "feet pounds-force per hour", "feet pounds-force per minute", "feet pounds-force per second", "horsepower (550 ft lbf/s)", "horsepower (boiler)", "horsepower (electric)", "horsepower (metric)", "horsepower (water)"]
    
    private var _torqueTypes = ["dyne centimeters", "newton meters", "ounce-force inches", "pound-force inches", "pound-force feet"]
    
    private var _temperatureTypes = ["degrees celcius", "kelvin", "degrees fahrenheit", "degrees rankine"]
    
    private var _pressureTypes = ["standard atmosphere", "pascal", "technical atmosphere", "bar", "millibar", "kilogram-force per square centimeter",
                                  "kilogram-force per square meter", "kilogram-force per square millimeter"]
    
    private var _electromagnitismTypes = ["statampere", "abampere", "ampere", "statcoulomb", "abcoulomb", "coulomb", "statvolt", "abvolt", "volt",
                                          "statfarad", "abfarad", "farad", "statohm", "abohm", "ohm", "statmho", "abmho", "siemens", "stathenry", "abhenry", "henry",
                                          "esu of electric field", "emu of electric field", "volt per meter", "esu of magnetic field", "gauss", "tesla"]
    
    private var _magneticsTypes = ["maxwell", "weber", "gamma", "gauss", "tesla"]
    
    private var _radiationTypes = ["roentgen", "coulombs per kilogram", "curies", "becquerels", "rad (gamma)", "rad (beta)", "rad (alpha)", "rad (neutron)",
                                   "gray (gamma)", "gray (alpha)", "gray (beta)", "gray (neutron)", "rem", "sieverts", "millisieverts"]
    
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
