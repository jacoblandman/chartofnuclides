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

typealias Completion = (_ error: NSError?, _ data: AnyObject?) -> Void
typealias facebookCompletion = (_ errMsg: String?,_ data: AnyObject?) -> Void
typealias errorDataCompletion = (_ error: NSError?, _ datat: AnyObject?) -> Void

class AuthService {
    private static let _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    func login(email: String, password: String, onComplete: Completion?) {
        print("JACOB: About to attempt to log in with username and password")
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onComplete?(error! as NSError, nil)
            } else {
                onComplete?(nil, user!)
                print("JACOB: SUCCESSFULLY LOGGED IN PREVIOUS USER")
            }
        })
    }
    
    func attemptCreateUser(withEmail email: String, password: String, onComplete: Completion?) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onComplete?(error! as NSError, nil)
            } else {
                // Sign in
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        onComplete?(error! as NSError, nil)
                    } else {
                        onComplete?(nil, user!)
                        print("JACOB: SUCCESSFULLY MADE NEW USER AND LOGGED IN")
                    }
                })
            }
        })
    }
    
    func deleteCurrentUser(uid: String, username: String?, imageURL: String, completed: errorCompletion?) {
        if let user = FIRAuth.auth()?.currentUser {
            
            if imageURL != "" {
                DataService.instance.deleteImage(forURL: imageURL, uid: user.uid, completed: nil)
            }
            
            user.delete(completion: { (error) in
                if error != nil {
                    completed?(error! as NSError?)
                    print("JACOB: An error occured trying to delete the user: \(error!.localizedDescription)")
                } else {
                    // the username is optional because the user may cancel the sign up process before choosing a username
                    if let username = username {
                        DataService.instance.delete(username)
                        DataService.instance.deleteUserDataWith(uid)
                        print("JACOB: Succesfully deleted user")
                    }
                    
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
    
    func reauthenticateUser(withCredential credential: FIRAuthCredential, completed: errorDataCompletion?) {
        
        if let user = FIRAuth.auth()?.currentUser {
            user.reauthenticate(with: credential, completion: { (error) in
                if error != nil {
                    completed?(error! as NSError, nil)
                } else {
                    completed?(nil, nil)
                    print("JACOB: reauthentication successful")
                }
            })
        } else {
            print("JACOB: Error: The current user doesn't exist")
            completed?(NSError(), nil)
        }
    }
    
    func authenticateWithFacebook(fromVC: UIViewController, reauthenticating: Bool, completed: errorDataCompletion?, cancelCompletion: @escaping ()->() ) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: fromVC) { (result, error) in
            if error != nil {
                completed?(error! as NSError?, nil)
            } else if result?.isCancelled == true {
                cancelCompletion()
            } else {
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                if reauthenticating {
                    self.reauthenticateUser(withCredential: credential, completed: completed)
                } else {
                    self.loginWithFacebook(credential, completed: completed)
                }
            }
        }
    }
    
    func loginWithFacebook(_ credential: FIRAuthCredential, completed: errorDataCompletion?) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                completed?(error! as NSError?, nil)
            } else {
                // check if a previous user
                if let currentUser = user {
                    _ = DataService.instance.checkIfPreviousUser(uid: currentUser.uid, completed: { (isPreviousUser) in
                        if (isPreviousUser) {
                            completed?(nil, user)
                        } else {
                            completed?(nil, user)
                        }
                    })
                }
            }
        })
    }
}
