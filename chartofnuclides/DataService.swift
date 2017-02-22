//
//  DataService.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/3/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class DataService {
    
    static let instance = DataService()
    
    var numberOfIsotopes: Int = 0
    
    let FILENAME = "nuclides"
    let FILE_EXTENSION = "json"
    
    func parse_json() -> [Element] {
        
        var returnElements = [Element]()
        
        if let path = Bundle.main.path(forResource: FILENAME, ofType: FILE_EXTENSION) {
            if let jsonData = NSData(contentsOfFile: path) {
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: []) as? Dictionary<String, Any> {
                        if let elements = jsonResult["element"] as? [Dictionary<String, Any>] {
                            for (index, element) in elements.enumerated() {
                                returnElements.append(Element(element: element, elementIndex: index))
                            }
                        }
                    }
                } catch  {
                    // error the json serialization didnt work
                    print("JACOB: The json Serialization didn't work")
                }
            }
        }
        
        return returnElements
    }
}
