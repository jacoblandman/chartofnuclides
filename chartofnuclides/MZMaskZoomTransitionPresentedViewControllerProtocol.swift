//
//  MZMaskZoomTransitionPresentedViewControllerProtocol.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/16/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

@objc public protocol MZMaskZoomTransitionPresentedViewController {
 
    var largeView: UIView { get }
    var viewsToFadeIn: Array<UIView> { get }
    
    
}
