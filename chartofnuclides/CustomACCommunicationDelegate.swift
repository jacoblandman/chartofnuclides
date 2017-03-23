//
//  CustomACCommunicationDelegate.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/23/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//


protocol CustomACCommunicationDelegate {
        
    func set(needsDismiss: Bool)
    
    func post()
    
    func dismiss()
    
}
