//
//  UIViewExtension.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/20/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
import ObjectiveC

private var selectedIndexPathAssociationKey: UInt8 = 0
private var fromPointAssociationKey: UInt8 = 1

extension UIViewController {
    
    var selectedIndexPath: IndexPath! {
        get {
            return objc_getAssociatedObject(self, &selectedIndexPathAssociationKey) as? IndexPath
        }
        set(newValue) {
            objc_setAssociatedObject(self, &selectedIndexPathAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var fromPoint: CGPoint! {
        get {
            let value = objc_getAssociatedObject(self, &fromPointAssociationKey) as? NSValue
            return value!.cgPointValue
        }
        set(newValue) {
            let value = NSValue(cgPoint: newValue)
            objc_setAssociatedObject(self, &fromPointAssociationKey, value, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
