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
                
            case .errorCodeInvalidCustomToken:
                return "Error with the custom token"
                
            case .errorCodeCustomTokenMismatch:
                return "The service account and the API key belong to different projects"
                
            case .errorCodeInvalidCredential:
                return "The IDP token or requestUri is invalid"
                
            case .errorCodeUserDisabled:
                return "The user's account is disabled on the server"
                
            case .errorCodeOperationNotAllowed:
                return "The administrator disabled sign in with the specified identity provider"
                
            case .errorCodeTooManyRequests:
                return "Too many requests were made to a server method"
                
            case .errorCodeUserNotFound:
                return "The user account was not found"
                
            case .errorCodeRequiresRecentLogin:
                return "The user has attemped to change email or password more than 5 minutes after signing in"
                
            case .errorCodeProviderAlreadyLinked:
                return "An attempt was made to link a provider to which the account is already linked"
                
            case .errorCodeNoSuchProvider:
                return "An attempt was made to unlink a provider that is not linked"
                
            case .errorCodeInvalidUserToken:
                return "The user's saved auth credential is invalid, the user needs to sign in again"
                
            case .errorCodeNetworkError:
                return "A network error occurred (such as a timeout, interrupted connection, or unreachable host). These types of errors are often recoverable with a retry."
                
            case .errorCodeUserTokenExpired:
                return "The saved token has expired."
                
            case .errorCodeInvalidAPIKey:
                return "An invalid API key was supplied in the request"
                
            case .errorCodeUserMismatch:
                return "An attempt was made to reauthenticate with a user which is not the current user"
                
            case .errorCodeCredentialAlreadyInUse:
                return "An attempt was made to link with a credential that has already been linked with a different Firebase account"
                
            case .errorCodeWeakPassword:
                return "An attempt was made to set a password that is considered too weak"
                
            case .errorCodeAppNotAuthorized:
                return "The App is not authorized to use Firebase Authentication with the provided API Key"
                
            case .errorCodeKeychainError:
                return "An error occurred while attempting to access the keychain"
                
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
