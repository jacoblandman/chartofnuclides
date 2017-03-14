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
    
    private var _unitTypeAbbsDict: Dictionary<String, Dictionary<String, Any>>
    
    
    // units for each unit type
    private var _angleTypes = ["degrees", "radians", "grades", "minutes", "seconds", "solid angle", "square degrees", "steradians"]
    
    private var _lengthTypes = ["angstroms", "meters", "astronomical units", "feet", "inches", "light years", "mils", "miles", "nautical miles", "parsecs",
                                "yards", "links", "survey feet", "rods", "chains", "statute miles", "furlongs", "yottameters", "zettameters",
                                "exameters", "petameters", "terameters", "gigameters", "megameters", "kilometers", "hectometers", "dekameters", "decimeters",
                                "centimeters", "millimeters", "micrometers", "nanometers", "picometers", "femtometers", "attometers", "zeptometers", "yoctometers"]
    
    private var _areaTypes = ["barns", "square meters", "hectares", "square feet", "square inches", "square miles", "square yards",
                              "square survey feet", "acres", "square survey miles",
                              "square kilometers", "square hectometers", "square dekameters", "square decimeters", "square centimeters",
                              "square millimeters", "square micrometers", "square nanometers"]
    
    private var _volumeTypes = ["cubic feet", "cubic meters", "cubic inches", "cubic yards", "liters", "steres",
                                "dry pints", "dry quarts", "bushels", "fluid ounces", "liquid pints",
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

    
    // abbreviation dictionaries
    private var _angleAbbs = ["degrees": "angle", "radians": "rad", "grades": "gon", "minutes": "angle", "seconds": "angle", "solid angle": "sr", "square degrees": "angle".squared(), "steradians": "sr"] as [String : Any]
    
    private var _lengthAbbs = ["angstroms": "Å", "meters": "m", "astronomical units": "AU", "feet": "ft", "inches": "in", "light years": "ly", "mils": "mil",
                               "miles": "mi", "nautical miles": "mi", "parsecs": "pc",
                               "yards": "yd", "links": "lnk", "survey feet": "ft", "rods": "rod", "chains": "chain", "statute miles": "mi", "furlongs": "fur",
                               "yottameters": "Ym", "zettameters": "Zm", "exameters": "Em", "petameters": "Pm", "terameters": "Tm", "gigameters": "Gm",
                               "megameters": "Mm", "kilometers": "km", "hectometers": "hm", "dekameters": "dam", "decimeters": "dm",
                               "centimeters": "cm", "millimeters": "mm", "micrometers": "μm", "nanometers": "nm", "picometers": "pm",
                               "femtometers": "fm", "attometers": "am", "zeptometers": "zm", "yoctometers": "ym"]
    
    private var _areaAbbs = ["barns": "b", "square meters": "m".squared(), "hectares": "ha", "square feet": "ft".squared(), "square inches": "in".squared(),
                             "square miles": "mi".squared(), "square yards": "yd".squared(),
                              "square survey feet": "ft".squared(), "acres": "ac", "square survey miles": "mi".squared(),
                              "square kilometers": "km".squared(), "square hectometers": "hm".squared(), "square dekameters": "dam".squared(),
                              "square decimeters": "dm".squared(), "square centimeters": "cm".squared(),
                              "square millimeters": "mm".squared(), "square micrometers": "μm".squared(), "square nanometers": "nm".squared()] as [String : Any]
    
    private var _volumeAbbs = ["cubic feet": "ft".cubed(), "cubic meters": "m".cubed(), "cubic inches": "in".cubed(), "cubic yards": "yd".cubed(),
                               "liters": "L", "steres": "st",
                                "dry pints": "pt", "dry quarts": "qt", "bushels": "bsh", "fluid ounces": "oz", "liquid pints": "pt",
                                "liquid quarts": "qt", "gallons": "gal", "cubic gigameters": "Gm".cubed(), "cubic megameters": "Mm".cubed(),
                                "cubic kilometers": "km".cubed(),
                                "cubic hectometers": "hm".cubed(), "cubic dekameters": "dam".cubed(), "cubic decimeters": "dm".cubed(), "cubic centimeters": "cm".cubed(),
                                "cubic millimeters": "mm".cubed(), "cubic micrometers": "μm".cubed(), "cubic nanometers": "nm".cubed()] as [String : Any]
    
    private var _massAbbs = ["grams": "g", "kilograms": "kg", "grains": "gr", "drams": "dr", "ounces": "oz",
                             "pounds": "lb", "short tons": "t", "stones": "st", "metric tons": "t", "tonnes": "t"]
    
    private var _timeAbbs = ["seconds": "s", "minutes": "min", "hours": "h", "days": "d", "years": "a", "shakes": "sh"]
    
    private var _densityAbbs = ["grams per cubic centimeter": "g/cm".cubed(), "pounds per cubic foot": "lb/ft".cubed(), "pounds per cubic inch": "lb/in".cubed(),
                                 "grams per cubic meter": "g/m".cubed(), "kilograms per cubic centimeter": "kg/cm".cubed(),
                                 "kilograms per cubic meter": "kg/m".cubed()] as [String : Any]
    
    private var _velocityAbbs = ["feet per hour": "ft/h", "meters per second": "m/s", "feet per minute": "ft/min", "feet per second": "ft/s",
                                 "inches per second": "in/s", "kilometers per hour": "km/h"]
    
    private var _angularvelocityAbbs = ["revolutions per second": "rev/s", "radians per second": "rad/s", "revolutions per minute": "rev/min", "degrees per second": "deg/s"]
    
    private var _accelerationAbbs = ["feet per second squared": "ft/s".squared(), "meters per second squared": "m/s".squared(), "standard free fall": "g",
                                     "inches per second squared": "in/s".squared(), "centimeters per second squared": "cm/s".squared()] as [String : Any]
    
    private var _forceAbbs = ["pounds-force": "lbf", "newtons": "N", "ounces-force": "ozf", "poundals": "lbm", "kips": "kip", "dynes": "dyn"]
    
    private var _workAbbs = ["electronvolts": "eV", "joules": "J", "calories (15°C)": "cal", "calories (20°C)": "cal", "calories (mean)": "cal",
                             "Btus (39°F)": "Btu", "Btus (59°F)": "Btu", "Btus (60°F)": "Btu", "Btus (mean)": "Btu",
                              "ergs": "erg", "feet poundals": "ft-lbm", "feet pounds-force": "ft-lbf", "kilowatt hours": "kW-h",
                              "watt hours": "W-h", "watt seconds": "W-s", "tons (nuclear equivalent of TNT)": "t"]
    
    private var _powerAbbs = ["Btus (mean) per second": "Btu/s", "watts": "W", "ergs per second": "erg/s", "feet pounds-force per hour": "ft-lbf/h",
                              "feet pounds-force per minute": "ft-lbf/min", "feet pounds-force per second": "ft-lbf/s", "horsepower (550 ft lbf/s)": "hp",
                              "horsepower (boiler)": "hp", "horsepower (electric)": "hp", "horsepower (metric)": "hp", "horsepower (water)": "hp"]
    
    private var _torqueAbbs = ["dyne centimeters": "dyn-cm", "newton meters": "N-m", "ounce-force inches": "ozf-in",
                               "pound-force inches": "lbf-in", "pound-force feet": "lbf-ft"]
    
    private var _temperatureAbbs = ["degrees celcius": "°C", "kelvin": "K", "degrees fahrenheit": "°F", "degrees rankine": "°R"]
    
    private var _pressureAbbs = ["standard atmosphere": "Atm", "pascal": "Pa", "technical atmosphere": "Atm", "bar": "b", "millibar": "mb",
                                 "kilogram-force per square centimeter": "kgf/cm".squared(), "kilogram-force per square meter": "kgf/m".squared(),
                                 "kilogram-force per square millimeter": "kgf/mm".squared()] as [String : Any]
    
    private var _electromagnitismAbbs = ["statampere": "A-esu", "abampere": "A-emu", "ampere": "A", "statcoulomb": "C-esu", "abcoulomb": "C-emu",
                                         "coulomb": "C", "statvolt": "V-esu", "abvolt": "V-emu", "volt": "V",
                                          "statfarad": "F-esu", "abfarad": "F-emu", "farad": "F", "statohm": "Ω-esu",
                                          "abohm": "Ω-emu", "ohm": "Ω", "statmho": "S-esu", "abmho": "S-emu", "siemens": "S",
                                          "stathenry": "H-esu", "abhenry": "H-emu", "henry": "H", "esu of electric field": "V/m-esu",
                                          "emu of electric field": "V/m-emu", "volt per meter": "V/m", "esu of magnetic field": "T-esu",
                                          "gauss": "Gs", "tesla": "T"]
    
    private var _magneticsAbbs = ["maxwell": "Mx", "weber": "Wb", "gamma": "γ", "gauss": "Gs", "tesla": "T"]
    
    private var _radiationAbbs = ["roentgen": "R", "coulombs per kilogram": "C/kg", "curies": "Ci", "becquerels": "Bq",
                                  "rad (gamma)": "rad", "rad (beta)": "rad", "rad (alpha)": "rad", "rad (neutron)": "rad",
                                  "gray (gamma)": "Gy", "gray (alpha)": "Gy", "gray (beta)": "Gy", "gray (neutron)": "Gy",
                                  "rem": "rem", "sieverts": "Sv", "millisieverts": "mSv"]
    
    override init() {
        _unitTypesDict = ["Angle": _angleTypes, "Length": _lengthTypes, "Area": _areaTypes, "Volume": _volumeTypes,
                          "Mass": _massTypes, "Time": _timeTypes, "Density": _densityTypes, "Velocity": _velocityTypes,
                          "Angular Velocity": _angularvelocityTypes, "Acceleration": _accelerationTypes, "Force": _forceTypes,
                          "Work": _workTypes, "Power": _powerTypes, "Torque": _torqueTypes, "Temperature": _temperatureTypes,
                          "Pressure": _pressureTypes, "Electromagnitism": _electromagnitismTypes, "Magnetics": _magneticsTypes,
                          "Radiation": _radiationTypes]
        
        _unitTypeAbbsDict = ["Angle": _angleAbbs, "Length": _lengthAbbs, "Area": _areaAbbs, "Volume": _volumeAbbs,
                            "Mass": _massAbbs, "Time": _timeAbbs, "Density": _densityAbbs, "Velocity": _velocityAbbs,
                            "Angular Velocity": _angularvelocityAbbs, "Acceleration": _accelerationAbbs, "Force": _forceAbbs,
                            "Work": _workAbbs, "Power": _powerAbbs, "Torque": _torqueAbbs, "Temperature": _temperatureAbbs,
                            "Pressure": _pressureAbbs, "Electromagnitism": _electromagnitismAbbs, "Magnetics": _magneticsAbbs,
                            "Radiation": _radiationAbbs]

    }
    
    var unitTypes: [String] {
        return _unitTypes
    }
    
    var unitTypesDict: Dictionary<String, [String]> {
        return _unitTypesDict
    }
    
    var unitTypeAbbsDict: Dictionary<String, Dictionary<String, Any>> {
        return _unitTypeAbbsDict
    }
    
}
