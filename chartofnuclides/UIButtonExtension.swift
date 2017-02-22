//
//  UIButtonExtension.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/22/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

private var xoAssociationKey: UInt8 = 0

extension UIButton {
    var delegate: ButtonControllerDelegate! {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? ButtonControllerDelegate
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}
