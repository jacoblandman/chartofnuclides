//
//  AuthService.swift
//  spaceChat
//
//  Created by Jacob Landman on 1/23/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import Foundation
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void
typealias deleteUserCompletion = (_ errCode: FIRAuthErrorCode?) -> Void
typealias reauthenticationCompletion = (_ errMsg: String?) -> Void

class AuthService {
    private static let _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    func login(email: String, password: String, onComplete: Completion?) {
        print("JACOB: About to attempt to log in with username and password")
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                    if errorCode == .errorCodeUserNotFound {
                        // if the user hasn't loged in before an account will be created for them
                        self.attemptCreateUser(withEmail: email, password: password, onComplete: onComplete)
                    } else {
                        // Handle all other errors
                        print("JACOB: Could not sign in user, error: \(error.debugDescription)")
                        self.handleFirebaseError(error: error as! NSError, onComplete: onComplete)
                    }
                }
            } else {
                onComplete?(nil, user)
                print("JACOB: SUCCESSFULLY LOGGED IN PREVIOUS USER")
            }
        })
    }
    
    func attemptCreateUser(withEmail email: String, password: String, onComplete: Completion?) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                self.handleFirebaseError(error: error as! NSError, onComplete: onComplete)
                print("JACOB: Could not create user, error: \(error.debugDescription)")
            } else {
                if user?.uid != nil {
                    DataService.instance.saveUser(uid: user!.uid)
                    // Sign in
                    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            self.handleFirebaseError(error: error as! NSError, onComplete: onComplete)
                            print("JACOB: Could not sign in user, error: \(error.debugDescription)")
                        } else {
                            onComplete?(nil, user)
                            print("JACOB: SUCCESSFULLY MADE NEW USER AND LOGGED IN")
                        }
                    })
                } else {
                    print("JACOB: The user uid is nil")
                }
            }
        })
    }
    
    func handleFirebaseError(error: NSError, onComplete: Completion?) {
        print(error.debugDescription)
        if let errorCode = FIRAuthErrorCode(rawValue: error._code) {
            switch (errorCode) {
            case .errorCodeInvalidEmail:
                onComplete?("Invalid email address", nil)
                break
                
            case .errorCodeWrongPassword:
                onComplete?("Invalid password", nil)
                break
                
            case .errorCodeEmailAlreadyInUse, .errorCodeAccountExistsWithDifferentCredential:
                onComplete?("Could not create account. Email already in use", nil)
                break
                
            default:
                onComplete?("There was a problem authenticating. Try again", nil)
                
            }
        }
    }
    
    func deleteCurrentUser(uid: String, username: String?, completed: deleteUserCompletion?) {
        if let user = FIRAuth.auth()?.currentUser {
            user.delete(completion: { (error) in
                if let error = error {
                    // may need to reauthenticate user here
                    if let errorCode = FIRAuthErrorCode(rawValue: error._code) {
                        completed?(errorCode)
                    }
                    print("JACOB: An error occured trying to delete the user: \(error.localizedDescription)")
                } else {
                    // the username is optional because the user may cancel the sign up process before choosing a username
                    if let username = username {
                       DataService.instance.delete(username)
                    }
                    DataService.instance.deleteUserDataWith(uid)
                    print("JACOB: Succesfully deleted user")
                    completed?(nil)
                }
            })
        }
    }
    
    func signOutCurrentUser() {
        if let _ = FIRAuth.auth()?.currentUser {
            do {
               try FIRAuth.auth()?.signOut()
            } catch let error as NSError {
                print("JACOB: Error signing out: \(error.localizedDescription)")
            }
        }
    }
    
    func reauthenticateUser(withCredential credential: FIRAuthCredential, completed: reauthenticationCompletion?) {
        
        let currentUser = FIRAuth.auth()?.currentUser
        
        if let user = currentUser {
            user.reauthenticate(with: credential, completion: { (error) in
                if error != nil {
                    self.handleReauthenticationError(error: error as! NSError, completed: completed)
                } else {
                    completed?(nil)
                    print("JACOB: reauthentication successful")
                }
            })
        } else {
            completed?("Error: The current user doesn't exist.")
        }
    }
    
    func handleReauthenticationError(error: NSError, completed: reauthenticationCompletion?) {
        print("JACOB: Need to handle reauthentication error")
    }
    
    func authenticateWithFacebook(fromVC: UIViewController, completed: Completion?) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: fromVC) { (result, error) in
            if error != nil {
                print("JACOB: Unable to authenticate with Facebook - \(error)")
                completed?(error!.localizedDescription, nil)
            } else if result?.isCancelled == true {
                print("JACOB: User cancelled Facebook authentication")
                completed?("User cancelled authentication", nil)
            } else {
                print("JACOB: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.loginWithFacebook(credential, completed: completed)
            }
        }
    }
    
    func loginWithFacebook(_ credential: FIRAuthCredential, completed: Completion?) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("JACOB: Unable to authenticate with Firebase - \(error)")
                completed?(error!.localizedDescription, nil)
            } else {
                print("JACOB: Successfully authenticated with Firebase")
                
                // check if a previous user
                if let currentUser = user {
                    
                    _ = DataService.instance.checkIfPreviousUser(uid: currentUser.uid, completed: { (isPreviousUser) in
                        if (isPreviousUser) {
                            completed?(nil, user)
                        } else {
                            DataService.instance.saveUser(uid: currentUser.uid)
                            completed?(nil, user)
                        }
                    })
                }
            }
        })
    }
}
