//
//  sendDataToPreviousViewController.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/21/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

protocol SendDataToPreviousControllerDelegate {
    func sendDataToA(data: Any)
    func signalRefresh()
}

// default implementation for optional functions
extension SendDataToPreviousControllerDelegate {
    func signalRefresh() {
        
    }
}
