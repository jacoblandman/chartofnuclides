//
//  ErrorHandler.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/15/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
import FirebaseAuth

class ErrorHandler: NSObject {
    static func handleFirebaseError(error: NSError) -> String {
        print(error.debugDescription)
        if let errorCode = FIRAuthErrorCode(rawValue: error._code) {
            
            switch (errorCode) {
            case .errorCodeInvalidEmail:
                return "Invalid email address"
                
            case .errorCodeWrongPassword:
                return "Invalid password"
                
            case .errorCodeEmailAlreadyInUse, .errorCodeAccountExistsWithDifferentCredential:
                return "Could not create account. Email already in use"
                
            default:
                return "There was a problem authenticating. Try again"
                
            }
        } else {
            return "Unknown error occurred. Please try again"
        }
    }
    
    static func handleDeletionError(error: NSError) -> Bool {
        if let errorCode = FIRAuthErrorCode(rawValue: error._code) {
            switch(errorCode) {
            case .errorCodeInvalidUserToken:
                return true
                
            case .errorCodeRequiresRecentLogin:
                return true
                
            default:
                // alert user to log out and log back in
                return false
            }
        }
        
        // some sort of error occurred.
        // alert the user that they should log out and log back in
        return false
    }
    
    static func handleImageDownloadError(error: NSError) {
        
    }
    
}
